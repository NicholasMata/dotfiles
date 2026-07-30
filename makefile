SHELL := /bin/sh

BREW := $(shell command -v brew 2>/dev/null)
STYLUA := $(shell command -v stylua 2>/dev/null)
BREWFILE := $(CURDIR)/Brewfile
STYLUA_CONFIG := $(CURDIR)/nvim/.config/nvim/stylua.toml
STOW_PACKAGES := aerospace ghostty herdr nvim zsh
NODE_TOOLS_SOURCE := $(CURDIR)/node-tools
NODE_TOOLS_HOME := $(HOME)/.local/share/dotfiles-node-tools
USER_BIN := $(HOME)/.local/bin
ZINIT_HOME := $(if $(XDG_DATA_HOME),$(XDG_DATA_HOME),$(HOME)/.local/share)/zinit/zinit.git

.PHONY: all install dependencies node-dependencies zinit stow delete check

all: install

install: dependencies zinit stow

dependencies:
ifndef BREW
	$(error Homebrew is required. Install it from https://brew.sh, then run `make install` again)
endif
	$(BREW) bundle --file="$(BREWFILE)"

node-dependencies:
	@test -n "$(NVM_BIN)" && test -x "$(NVM_BIN)/npm" || { echo "An active NVM-managed Node version is required. Run 'nvm use 20', then try again."; exit 1; }
	@test "$$("$(NVM_BIN)/node" --print 'process.versions.node.split(".")[0]')" = "20" || { echo "Node 20 is required. Run 'nvm use 20', then try again."; exit 1; }
	mkdir -p "$(NODE_TOOLS_HOME)"
	install -m 0644 "$(NODE_TOOLS_SOURCE)/package.json" "$(NODE_TOOLS_SOURCE)/package-lock.json" "$(NODE_TOOLS_HOME)"
	"$(NVM_BIN)/npm" ci --prefix="$(NODE_TOOLS_HOME)"
	mkdir -p "$(USER_BIN)"
	install -m 0755 "$(NODE_TOOLS_SOURCE)/webtorrent" "$(USER_BIN)/webtorrent"

zinit:
	@test -d "$(ZINIT_HOME)/.git" || { mkdir -p "$(dir $(ZINIT_HOME))"; git clone https://github.com/zdharma-continuum/zinit.git "$(ZINIT_HOME)"; }

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
	@for command in aerospace git ghostty nvim stow stylua taplo zsh; do command -v "$$command" >/dev/null || { echo "Missing required command: $$command"; exit 1; }; done
	$(BREW) bundle check --no-upgrade --file="$(BREWFILE)"
	zsh -n zsh/.zshenv zsh/.zshrc
	$(STYLUA) --config-path="$(STYLUA_CONFIG)" --check nvim/.config/nvim scripts
	taplo check aerospace/.config/aerospace/aerospace.toml aerospace/.config/aerospace/aerospace.vim.toml herdr/.config/herdr/config.toml
	ghostty +validate-config --config-file="$(CURDIR)/ghostty/.config/ghostty/config"
	nvim --headless -u NONE "+lua for _, path in ipairs(vim.fn.glob('nvim/.config/nvim/**/*.lua', false, true)) do assert(loadfile(path)) end" +qa
	nvim -i NONE --headless "+lua dofile('scripts/check-nvim.lua')" +qa
	git diff --check
