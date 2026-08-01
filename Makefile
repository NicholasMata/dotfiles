SHELL := /bin/sh

BREW := $(shell command -v brew 2>/dev/null)
STYLUA := $(shell command -v stylua 2>/dev/null)
BREWFILE := $(CURDIR)/Brewfile
STYLUA_CONFIG := $(CURDIR)/nvim/.config/nvim/stylua.toml
STOW_PACKAGES := aerospace ghostty herdr nvim zsh
NODE_TOOLS_SOURCE := $(CURDIR)/node-tools
NODE_TOOLS_HOME := $(HOME)/.local/share/dotfiles-node-tools
NODE_VERSION := 24
USER_BIN := $(HOME)/.local/bin
MARKDOWNLINT := $(USER_BIN)/markdownlint-cli2
ZINIT_HOME := $(if $(XDG_DATA_HOME),$(XDG_DATA_HOME),$(HOME)/.local/share)/zinit/zinit.git
ZINIT_REPOSITORY := https://github.com/zdharma-continuum/zinit.git
ZINIT_VERSION := v3.15.0
ZINIT_REVISION := 429ab136312dfce68ad7d87a0ecb08c5063e7287

.PHONY: all install dependencies node-dependencies zinit stow delete check

all: install

install: dependencies zinit stow

dependencies:
ifndef BREW
	$(error Homebrew is required. Install it from https://brew.sh, then run `make install` again)
endif
	$(BREW) bundle --file="$(BREWFILE)"

node-dependencies:
	@test -n "$(NVM_BIN)" && test -x "$(NVM_BIN)/npm" || { echo "An active NVM-managed Node version is required. Run 'nvm use $(NODE_VERSION)', then try again."; exit 1; }
	@test "$$("$(NVM_BIN)/node" --print 'process.versions.node.split(".")[0]')" = "$(NODE_VERSION)" || { echo "Node $(NODE_VERSION) is required. Run 'nvm use $(NODE_VERSION)', then try again."; exit 1; }
	mkdir -p "$(NODE_TOOLS_HOME)"
	install -m 0644 "$(NODE_TOOLS_SOURCE)/package.json" "$(NODE_TOOLS_SOURCE)/package-lock.json" "$(NODE_TOOLS_HOME)"
	"$(NVM_BIN)/npm" ci --ignore-scripts --prefix="$(NODE_TOOLS_HOME)"
	"$(NVM_BIN)/npm" rebuild --prefix="$(NODE_TOOLS_HOME)" node-datachannel bufferutil utf-8-validate utp-native
	mkdir -p "$(USER_BIN)"
	install -m 0755 "$(NODE_TOOLS_SOURCE)/markdownlint-cli2" "$(USER_BIN)/markdownlint-cli2"
	install -m 0755 "$(NODE_TOOLS_SOURCE)/webtorrent" "$(USER_BIN)/webtorrent"

zinit:
	@if test ! -d "$(ZINIT_HOME)/.git"; then \
		mkdir -p "$(dir $(ZINIT_HOME))"; \
		git clone --branch "$(ZINIT_VERSION)" --depth 1 "$(ZINIT_REPOSITORY)" "$(ZINIT_HOME)"; \
	elif test "$$(git -C "$(ZINIT_HOME)" rev-parse HEAD)" != "$(ZINIT_REVISION)"; then \
		test -z "$$(git -C "$(ZINIT_HOME)" status --porcelain)" || { echo "Zinit has local changes; refusing to replace them."; exit 1; }; \
		git -C "$(ZINIT_HOME)" fetch --depth 1 origin tag "$(ZINIT_VERSION)"; \
		git -C "$(ZINIT_HOME)" checkout --detach "$(ZINIT_REVISION)"; \
	fi
	@test "$$(git -C "$(ZINIT_HOME)" rev-parse HEAD)" = "$(ZINIT_REVISION)" || { echo "Zinit $(ZINIT_VERSION) did not resolve to $(ZINIT_REVISION)."; exit 1; }

stow:
	stow --verbose --target="$(HOME)" --restow $(STOW_PACKAGES)

delete:
	stow --verbose --target="$(HOME)" --delete $(STOW_PACKAGES)

check:
ifndef BREW
	$(error Homebrew is required to validate the Brewfile)
endif
ifndef STYLUA
	$(error StyLua is required for formatting checks. Run `make dependencies` to install it)
endif
	@for package in $(STOW_PACKAGES); do test -d "$$package" || { echo "Missing Stow package: $$package"; exit 1; }; done
	@test -x "$(MARKDOWNLINT)" || { echo "markdownlint-cli2 is required. Run 'nvm use $(NODE_VERSION) && make node-dependencies' to install it."; exit 1; }
	@for command in aerospace git ghostty nvim stow stylua taplo zsh; do command -v "$$command" >/dev/null || { echo "Missing required command: $$command"; exit 1; }; done
	$(BREW) bundle check --no-upgrade --file="$(BREWFILE)"
	zsh -n zsh/.zshenv zsh/.zshrc node-tools/markdownlint-cli2 node-tools/webtorrent
	"$(MARKDOWNLINT)" README.md
	$(STYLUA) --config-path="$(STYLUA_CONFIG)" --check nvim/.config/nvim
	taplo check aerospace/.config/aerospace/aerospace.toml herdr/.config/herdr/config.toml
	ghostty +validate-config --config-file="$(CURDIR)/ghostty/.config/ghostty/config"
	nvim --headless -u NONE "+lua for _, path in ipairs(vim.fn.glob('nvim/.config/nvim/**/*.lua', false, true)) do assert(loadfile(path)) end" +qa
	nvim -i NONE --headless +qa
	git diff --check
