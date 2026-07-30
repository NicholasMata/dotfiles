SHELL := /bin/sh

BREW := $(shell command -v brew 2>/dev/null)
STYLUA := $(shell command -v stylua 2>/dev/null)
BREWFILE := $(CURDIR)/Brewfile
STOW_PACKAGES := aerospace ghostty herdr nvim zsh
ZINIT_HOME := $(if $(XDG_DATA_HOME),$(XDG_DATA_HOME),$(HOME)/.local/share)/zinit/zinit.git

.PHONY: all install dependencies zinit stow delete check

all: install

install: dependencies zinit stow

dependencies:
ifndef BREW
	$(error Homebrew is required. Install it from https://brew.sh, then run `make install` again)
endif
	$(BREW) bundle --file="$(BREWFILE)"

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
	$(error StyLua is required for formatting checks. Open Neovim once so Mason can install it)
endif
	@for package in $(STOW_PACKAGES); do test -d "$$package" || { echo "Missing Stow package: $$package"; exit 1; }; done
	$(BREW) bundle list --file="$(BREWFILE)" >/dev/null
	zsh -n zsh/.zshenv zsh/.zshrc
	$(STYLUA) --check nvim/.config/nvim
	nvim --headless -u NONE "+lua for _, path in ipairs(vim.fn.glob('nvim/.config/nvim/**/*.lua', false, true)) do assert(loadfile(path)) end" +qa
	git diff --check
