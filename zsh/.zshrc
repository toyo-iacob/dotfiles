export PATH="$HOME/.local/bin:$PATH"

# ---- Brew -----

export PATH="/opt/homebrew/bin:$PATH"

# ---- Default config path for other stuff -----
export XDG_CONFIG_HOME="$HOME/.config"

# ---- History settings -----

export HISTTIMEFORMAT="%h %d %H:%M:%S "
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTFILE=$HOME/.zhistory
# setopt append_history          # Save history across sessions
# setopt inc_append_history      # Write immediately instead of waiting for logout
setopt share_history           # Share history between all sessions
setopt hist_expire_dups_first  # Expire duplicate entries first
setopt hist_ignore_dups        # Ignore duplicates in history
setopt hist_reduce_blanks      # Remove unnecessary blanks in history
setopt hist_verify             # Don't execute immediately, allow editing
setopt extended_history        # Save timestamps for history

# ---- Go -----

export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
alias mod='go mod tidy && go mod download && go mod vendor'

# ---- Docker -----


# ---- GNU GPG -----

export GPG_TTY=$(tty)

# ---- Fzf -----

# Use fd instead of fzf
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 40% --border --layout=reverse --info=inline"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}


# ---- Zoxide -----

eval "$(zoxide init --cmd cd zsh)"

# ---- Yazi -----

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ---- Aliases -----

alias v='nvim'
alias l='eza -la --icons'           # Better ls
alias ll='eza -lh --icons'          # Long list
alias la='eza -la --icons'          # All files
alias df='duf'                      # Use duf for disk usage
alias cat='bat --paging=never'      # Better cat
alias rm='rm -i'                    # Confirm before deleting

eval $(thefuck --alias)
eval $(thefuck --alias fk)

alias k='kubectl'
alias kg='kubectl get pods'
alias kga='kubectl get all'
alias kd='kubectl describe'
alias docker-stop-all='docker ps -q | xargs -r docker stop'
alias docker-update='docker image ls --format "{{.Repository}}:{{.Tag}}" | grep 410715645895.dkr.ecr.us-east-1.amazonaws.com | while read line; do docker pull $line; done'

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "wintermi/zsh-starship"
export ZVM_INIT_MODE=sourcing && plug "jeffreytse/zsh-vi-mode"
plug "zsh-users/zsh-syntax-highlighting"
plug "MichaelAquilina/zsh-you-should-use"
plug "zap-zsh/exa"
plug "Aloxaf/fzf-tab"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Load and initialise completion system
autoload -Uz compinit
if [[ -n "$ZSH_COMPDUMP" ]]; then
  compinit -C
else
  compinit
fi

# ---- END -----

source $HOME/.zprofile
