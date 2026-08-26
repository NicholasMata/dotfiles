SHELL := /bin/sh

BREW := $(shell command -v brew 2>/dev/null)
STYLUA := $(shell command -v stylua 2>/dev/null)
BREWFILE := $(CURDIR)/Brewfile
OPTIONAL_BREWFILE := $(CURDIR)/Brewfile.optional
NVM_DEFAULT_PACKAGES := $(CURDIR)/zsh/.nvm/default-packages
STYLUA_CONFIG := $(CURDIR)/nvim/.config/nvim/stylua.toml
STOW_PACKAGES := aerospace ghostty herdr mouseless nanobar nvim zsh
ZINIT_HOME := $(if $(XDG_DATA_HOME),$(XDG_DATA_HOME),$(HOME)/.local/share)/zinit/zinit.git
ZINIT_REPOSITORY := https://github.com/zdharma-continuum/zinit.git
ZINIT_VERSION := v3.15.0
ZINIT_REVISION := 429ab136312dfce68ad7d87a0ecb08c5063e7287

.PHONY: all install install-optional dependencies optional-dependencies node-dependencies git-tools zinit stow delete check

all: install

install: dependencies zinit stow node-dependencies git-tools

install-optional: dependencies optional-dependencies zinit stow node-dependencies git-tools

dependencies:
ifndef BREW
	$(error Homebrew is required. Install it from https://brew.sh, then run `make install` again)
endif
	$(BREW) bundle --file="$(BREWFILE)"

optional-dependencies:
ifndef BREW
	$(error Homebrew is required. Install it from https://brew.sh, then run `make optional-dependencies` again)
endif
	$(BREW) bundle --file="$(OPTIONAL_BREWFILE)"

node-dependencies:
	@test -r "$(NVM_DEFAULT_PACKAGES)" || { echo "Missing NVM default package list: $(NVM_DEFAULT_PACKAGES)"; exit 1; }
	@test -n "$$NVM_DIR" || { echo "NVM is required. Install and activate an NVM-managed Node LTS release."; exit 1; }
	@case "$$(command -v npm 2>/dev/null)" in \
		"$$NVM_DIR"/versions/node/*) ;; \
		*) echo "npm must come from NVM. Run 'nvm install --lts' before 'make node-dependencies'."; exit 1 ;; \
	esac
	@while IFS= read -r package; do \
		case "$$package" in ''|'#'*) continue ;; esac; \
		npm install --global "$$package" || exit; \
	done < "$(NVM_DEFAULT_PACKAGES)"

git-tools:
	@command -v git >/dev/null || { echo "Git is required to configure Git tools."; exit 1; }
	@command -v nvim >/dev/null || { echo "Neovim is required to configure Git tools."; exit 1; }
	git config --global core.pager 'nvim -R -c "setlocal filetype=git nomodifiable" -c "nnoremap <buffer> q <cmd>qa!<cr>" -'
	git config --global color.pager false
	git config --global diff.tool nvimdiff
	git config --global difftool.prompt false

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
	@for command in aerospace git ghostty nvim rumdl selene stow stylua taplo zsh; do command -v "$$command" >/dev/null || { echo "Missing required command: $$command"; exit 1; }; done
	$(BREW) bundle check --no-upgrade --file="$(BREWFILE)"
	zsh -n zsh/.zshenv zsh/.zshrc
	rumdl check README.md
	selene nvim/.config/nvim
	$(STYLUA) --config-path="$(STYLUA_CONFIG)" --check nvim/.config/nvim
	taplo check aerospace/.config/aerospace/aerospace.toml herdr/.config/herdr/config.toml
	ghostty +validate-config --config-file="$(CURDIR)/ghostty/.config/ghostty/config"
	nvim --headless -u NONE "+lua for _, path in ipairs(vim.fn.glob('nvim/.config/nvim/**/*.lua', false, true)) do assert(loadfile(path)) end" +qa
	nvim -i NONE --headless +qa
	nvim -i NONE --headless "+lua require('mata.check').run()" +qa
	git diff --check
