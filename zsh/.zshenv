# Add to PATH only if directory exists and is not already in PATH
path_add() {
  [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"
}

export EDITOR="/opt/homebrew/bin/nvim"
export VISUAL="/opt/homebrew/bin/nvim"

export CLICOLOR=1

export DOTNET_ROOT="/usr/local/share/dotnet"

path_add "$HOME/.local/bin"
path_add "$HOME/.dotnet/tools"
path_add "$HOME/.local/share/nvim/mason/bin"
path_add "$HOME/Library/Android/sdk/platform-tools"
