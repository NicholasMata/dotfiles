SHELL := /bin/sh

BREW := $(shell command -v brew 2>/dev/null)
STYLUA := $(shell command -v stylua 2>/dev/null)
BREWFILE := $(CURDIR)/Brewfile
OPTIONAL_BREWFILE := $(CURDIR)/Brewfile.optional
STYLUA_CONFIG := $(CURDIR)/nvim/.config/nvim/stylua.toml
STOW_PACKAGES := aerospace ghostty herdr mouseless nanobar nvim zsh
ZINIT_HOME := $(if $(XDG_DATA_HOME),$(XDG_DATA_HOME),$(HOME)/.local/share)/zinit/zinit.git
ZINIT_REPOSITORY := https://github.com/zdharma-continuum/zinit.git
ZINIT_VERSION := v3.15.0
ZINIT_REVISION := 429ab136312dfce68ad7d87a0ecb08c5063e7287

.PHONY: all install install-optional dependencies optional-dependencies zinit stow delete check

all: install

install: dependencies zinit stow

install-optional: dependencies optional-dependencies zinit stow

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
	@for command in aerospace git ghostty nvim rumdl stow stylua taplo zsh; do command -v "$$command" >/dev/null || { echo "Missing required command: $$command"; exit 1; }; done
	$(BREW) bundle check --no-upgrade --file="$(BREWFILE)"
	zsh -n zsh/.zshenv zsh/.zshrc
	rumdl check README.md
	$(STYLUA) --config-path="$(STYLUA_CONFIG)" --check nvim/.config/nvim
	taplo check aerospace/.config/aerospace/aerospace.toml herdr/.config/herdr/config.toml
	ghostty +validate-config --config-file="$(CURDIR)/ghostty/.config/ghostty/config"
	nvim --headless -u NONE "+lua for _, path in ipairs(vim.fn.glob('nvim/.config/nvim/**/*.lua', false, true)) do assert(loadfile(path)) end" +qa
	nvim -i NONE --headless +qa
	nvim -i NONE --headless "+lua require('mata.check').run()" +qa
	git diff --check
