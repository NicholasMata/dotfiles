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
`make stow`. Optional Homebrew packages are excluded from these commands. Run
`make optional-dependencies` to install only the optional packages, or
`make install-optional` to install everything and apply the dotfiles.

## Prerequisites

- macOS with Xcode for Swift development, or Xcode Command Line Tools
  (`xcode-select --install`) when Swift development is not needed
- [Homebrew](https://brew.sh)
- [NVM](https://github.com/nvm-sh/nvm) for Node.js development and Neovim
  language tooling
- The [.NET SDK](https://dotnet.microsoft.com/download) for C# development

NVM, Xcode, and the .NET SDK are optional unless you use their corresponding
Neovim features. Before running `make install` with the Node.js features, use
`nvm install --lts` so `npm` resolves to an NVM-managed Node release. The
install target installs the packages in `~/.nvm/default-packages`; it refuses
to install them when `npm` is owned by another package manager. The optional
Homebrew bundle installs Temurin 21 for Kotlin language tooling; use each
project's Gradle wrapper (`./gradlew`) instead of requiring a global Gradle
installation. Zinit is installed by `make install`; it can also be installed
separately with `make zinit`. Its release tag and commit are pinned in the
Makefile so a new machine receives the same version. To upgrade Zinit, update
both `ZINIT_VERSION` and `ZINIT_REVISION`, then run `make zinit`.

Homebrew installs [rumdl](https://github.com/rvben/rumdl) and
[Selene](https://github.com/Kampfkarren/selene) for Markdown and Lua linting in
Neovim and repository checks. The optional Homebrew bundle installs
[SuperSeedeR](https://github.com/Jagalite/superseedr) as the terminal BitTorrent
client, replacing the Node-powered WebTorrent CLI. Neither tool requires Node.

## Neovim language development

The Neovim configuration provides language servers, completion, formatting,
and Treesitter parsing for C#, TypeScript/React, Swift, and Kotlin. Debugging
is configured for C#, Node.js, browser-based React applications, and Kotlin.
It also provides Microsoft SQL Server completion, object discovery,
connections, and query execution through `mssql.nvim`.

Tool ownership is split deliberately:

- Microsoft manages the .NET SDK, and Mason installs Roslyn and NetCoreDbg.
- NVM manages Node.js and the `codex-acp` package used by CodeCompanion, while
  Mason installs VTSLS, Biome, Prettierd, Oxlint, the CSS language server, and
  the JavaScript debug adapter.
- Xcode supplies Swift and SourceKit-LSP; Homebrew supplies SwiftFormat.
- Homebrew supplies Temurin 21; Mason installs the Kotlin language server,
  Ktlint, and the Kotlin debug adapter.
- Mason installs SQL Formatter, configured for Transact-SQL. `mssql.nvim`
  downloads and manages Microsoft SQL Tools Service itself.

ESLint remains project-local. Projects with an ESLint configuration should
list ESLint and any required plugins in their own `package.json`. Kotlin
projects should commit and use their Gradle wrapper. Run `:checkhealth mata`
inside Neovim to identify missing SDKs or language tools.

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

### [NanoBar](https://github.com/xeydev/nanobar)

NanoBar displays AeroSpace workspaces and their applications in a native bar
along the left edge of each monitor. AeroSpace notifies it when the focused
workspace changes, and the tracked configuration uses a compact blurred style.
Homebrew installs NanoBar, while `brew services start nanobar` enables its
per-user background service.

### [Herdr](https://herdr.dev/)

I use Herdr as a terminal-based agent multiplexer. These dotfiles configure its
Rosé Pine theme, workspace and pane key bindings, and navigation between Herdr
and Neovim.

### [Mouseless](https://mouseless.click/)

Mouseless provides keyboard-driven pointer control. Its grid, movement,
scrolling, mouse-button, and overlay key bindings are tracked in this
repository. License information and runtime state are intentionally excluded.

### [Neovim](https://neovim.io/)

Neovim is my main editor and my favorite after trying many editors over the
past two decades. I previously used LunarVim, but a custom configuration gives
me better performance and more control over personalization.

### Additional macOS applications

The Homebrew bundle also installs
[Nightfall](https://github.com/r-thomson/Nightfall/) for toggling macOS dark
mode. Nightfall does not have configuration tracked in this repository.

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
