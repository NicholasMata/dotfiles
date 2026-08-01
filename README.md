# Dotfiles

This repository stores my personal dotfiles. I recommend creating and
maintaining your own rather than applying these without review.

NOTE: I use GNU Stow to apply all the dotfiles in the repo to my home directory.

After installing [Homebrew](https://brew.sh), install the command-line dependencies
and macOS applications, then apply the dotfiles with:

```sh
make install
```

To install only the Homebrew dependencies and applications, run
`make dependencies`. To apply the dotfiles without running Homebrew, run
`make stow`.

## Prerequisites

- macOS with Xcode Command Line Tools (`xcode-select --install`)
- [Homebrew](https://brew.sh)
- [NVM](https://github.com/nvm-sh/nvm) for Node.js development and
  Node-powered Neovim tools
- The [.NET SDK](https://dotnet.microsoft.com/download) for C# development

NVM and the .NET SDK are optional unless you use their corresponding Neovim
features. Zinit is installed by `make install`; it can also be installed
separately with `make zinit`. Its release tag and commit are pinned in the
Makefile so a new machine receives the same version. To upgrade Zinit, update
both `ZINIT_VERSION` and `ZINIT_REVISION`, then run `make zinit`.

The Node-powered `webtorrent` and `markdownlint-cli2` commands are installed
through npm so Node remains managed by NVM rather than Homebrew. The locked
dependency graph keeps WebTorrent CLI 6 while overriding vulnerable transitive
packages where compatible. Installation skips package lifecycle scripts, then
rebuilds WebTorrent's required native modules. Install Node 24 LTS and activate
it before installing the command-line packages:

```sh
nvm install 24
nvm use 24
make node-dependencies
```

The wrappers installed by `make node-dependencies` always use NVM's Node 24,
regardless of the Node version active in the current shell.

Run the repository's non-destructive validation checks with:

```sh
make check
```

## Features

### [Ghostty](https://ghostty.org/)

I use Ghostty as my terminal. These dotfiles configure the following features:

- Specific rose-pine theme for light and dark mode
- Font setup
- Terminal background
- Dock icon customization
- Window decorations

### [Aerospace](https://github.com/nikitabobko/AeroSpace)

I use Aerospace as my tiling window manager because it works well on macOS. I
previously used SKHD and Yabai. Yabai uses private APIs to work with native
macOS Spaces, so operating-system updates could break it. Aerospace instead
uses virtual workspaces by hiding and showing windows. This loses some built-in
macOS functionality, but I am comfortable with that compromise.

### [Herdr](https://herdr.dev/)

I use Herdr as a terminal-based agent multiplexer. These dotfiles configure its
Rosé Pine theme, workspace and pane key bindings, and navigation between Herdr
and Neovim.

### [Neovim](https://neovim.io/)

Neovim is my main editor and my favorite after trying many editors over the
past two decades. I previously used LunarVim, but a custom configuration gives
me better performance and more control over personalization.

### Additional macOS applications

The Homebrew bundle also installs
[Mouseless](https://mouseless.click/) for keyboard-driven pointer control and
[Nightfall](https://github.com/r-thomson/Nightfall/) for toggling macOS dark
mode. They do not have configuration tracked in this repository.

### Powerlevel10k

[Powerlevel10k](https://github.com/romkatv/powerlevel10k) styles the terminal
prompt. The Homebrew bundle installs the MesloLG Nerd Font used by Ghostty and
Neovim. My configuration is based on Powerlevel10k's generated file, which is
why it is so large.

### zsh-autosuggestions

[This](https://github.com/zsh-users/zsh-autosuggestions) displays inline
terminal command suggestions based on command history.

### zsh-completions

[This](https://github.com/zsh-users/zsh-completions) adds completion
definitions for commands that are not covered by Zsh itself.

### fzf-tab

[fzf-tab](https://github.com/Aloxaf/fzf-tab) displays and filters completion
candidates when using tab completion.

### zsh-fzf-history-search

[This](https://github.com/joshskidmore/zsh-fzf-history-search) provides a
searchable menu for command history.

### zsh-syntax-highlighting

[This](https://github.com/zsh-users/zsh-syntax-highlighting) colors the command
line according to Zsh syntax.
