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
separately with `make zinit`.

The `webtorrent` command is installed through npm so Node remains managed by
NVM rather than Homebrew. Its locked dependency graph keeps WebTorrent CLI 6
on the npm-compatible `load-ip-set` release. Install Node 20 and activate it
before installing the command-line package:

```sh
nvm install 20
nvm use 20
make node-dependencies
```

The wrapper installed by `make node-dependencies` always runs WebTorrent with
NVM's Node 20, regardless of the Node version active in the current shell.

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

### [Neovim](https://neovim.io/)

Neovim is my main editor and my favorite after trying many editors over the
past two decades. I previously used LunarVim, but a custom configuration gives
me better performance and more control over personalization.

### Powerlevel10k

[Powerlevel10k](https://github.com/romkatv/powerlevel10k) styles the terminal
prompt. The Homebrew bundle installs the MesloLG Nerd Font used by Ghostty and
Neovim. My configuration is based on Powerlevel10k's generated file, which is
why it is so large.

### zsh-autosuggestions

[This](https://github.com/zsh-users/zsh-autosuggestions) suggests terminal
commands based on previously entered commands.

### zsh-completions

[This](https://github.com/zsh-users/zsh-completions) provides completion
suggestions below the prompt, in addition to a history menu.

### zsh-syntax-highlighting

[This](https://github.com/zsh-users/zsh-syntax-highlighting) adds syntax
highlighting for terminal commands.
