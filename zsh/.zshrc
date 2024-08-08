# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Set up zoxide and replace cd
eval "$(zoxide init --cmd cd zsh)"
