# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Set up zoxide and replace cd
eval "$(zoxide init --cmd cd zsh)"

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "wintermi/zsh-starship"
plug "zsh-users/zsh-syntax-highlighting"
plug "MichaelAquilina/zsh-you-should-use"
plug "zap-zsh/exa"
plug "Aloxaf/fzf-tab"

# Load and initialise completion system
autoload -Uz compinit
compinit
