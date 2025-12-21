# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS developer dotfiles repository using **GNU Stow** for symlink management. Each directory contains configuration files for a specific tool, and Stow creates symlinks from these directories into `$HOME` (typically `~/.config/`).

## Setup and Installation

### Initial Bootstrap
```bash
./setup.sh
```

This installs Homebrew, all development tools, creates SSH/GPG keys, and symlinks all configurations using Stow.

### Manual Steps After Setup
1. Add SSH key to GitHub: `cat ~/.ssh/github.pub`
2. Configure GPG for commit signing (see setup.sh output)
3. Launch tmux and press `prefix+I` to install TPM plugins
4. Enable AeroSpace in macOS System Settings
5. Disable Spotlight and configure Raycast shortcuts

### Updating Configurations
After modifying any dotfile, re-stow to update symlinks:
```bash
# Stow a specific tool
stow zsh -t $HOME

# Stow everything
for dir in */; do
  [ "$dir" != ".git/" ] && stow "$dir" -t "$HOME"
done

# Unstow before modifying
stow -D nvim -t $HOME
```

## Architecture

### Directory Structure
- **zsh/** - Shell configuration (main entry point: `.zshrc`)
- **nvim/** - Neovim editor (Lua-based, uses Lazy.nvim plugin manager)
- **tmux/** - Terminal multiplexer (uses TPM for plugins)
- **kitty/** - Terminal emulator
- **starship/** - Shell prompt customization
- **aerospace/** - macOS window manager
- **lazygit/** - Git UI configuration
- **gnupg/** - GPG/encryption settings

### Neovim Configuration
Location: `nvim/.config/nvim/`

Structure:
```
init.lua                    # Entry point (minimal, delegates to lazy.lua)
lua/
  config/                   # Core configuration
    keymaps.lua             # Key bindings (leader = space)
    options.lua             # Vim options
    autocmds.lua            # Auto commands
    diagnostics.lua         # LSP diagnostics
  plugins/                  # Plugin configurations (30+ plugins)
    lsp.lua                 # Language server setup
    conform.lua             # Code formatting
    telescope.lua           # Fuzzy finder
    claudecode.lua          # Claude Code integration
    ...
```

**Plugin Manager**: Lazy.nvim auto-bootstraps on first run and lazy-loads plugins

**Language Servers** (managed by Mason):
- Go: gopls, goimports, gofumpt, golangci-lint
- Python: pylsp, pylint
- JavaScript/TypeScript: ts_ls, eslint_d, prettierd
- Bash: bashls, shellcheck
- Infrastructure: terraformls, helm_ls, docker_ls, nginx_language_server
- Protobuf: buf_ls, pbls
- SQL: sqls, sql-formatter

### Key Keybindings

Leader key: `<Space>`

**Claude Code**:
- `<leader>ac` - Toggle Claude Code terminal
- `<leader>aC` - Continue conversation
- `<leader>aV` - Verbose output

**Navigation**:
- `<C-p>` or `<leader>p` - Telescope file finder
- `<leader>f` - Live grep in project
- `]b` / `[b` - Next/previous buffer
- `<leader>w` - Close current buffer

**Editing**:
- `<leader>r` - Replace word under cursor (buffer-wide)
- `J` / `K` (visual) - Move selected block down/up
- `<leader>y` / `<leader>p` - Yank/paste to system clipboard
- `<leader>d` - Delete to black hole register

**Git** (via gitsigns, fugitive, lazygit):
- `<leader>gg` - Open Lazygit
- `<leader>gr` - Reset hunk
- `<leader>gb` - Git blame line

**Window Management** (AeroSpace):
- `alt+h/j/k/l` - Focus window in direction
- `alt+shift+h/j/k/l` - Move window
- `alt+1-9` - Switch workspace

### Shell Configuration

Location: `zsh/.zshrc`

**Key Environment Variables**:
```bash
XDG_CONFIG_HOME=$HOME/.config
GOPATH=$HOME/go
GPG_TTY=$(tty)
FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --strip-cwd-prefix --exclude .git"
```

**Useful Aliases**:
```bash
v='nvim'
l='eza -la --icons'
cat='bat --paging=never'
k='kubectl'
mod='go mod tidy && go mod download && go mod vendor'
docker-stop-all='docker ps -q | xargs -r docker stop'
```

**Functions**:
- `yy` - Open Yazi file manager with directory change on exit
- `cd` - Actually zoxide (`cd` is aliased to zoxide for smart directory jumping)

**Zsh Plugins** (via Zap):
- zsh-autosuggestions - Command suggestions
- zsh-vi-mode - Vi keybindings in shell
- zsh-syntax-highlighting - Syntax highlighting
- fzf-tab - FZF-based tab completion
- zsh-you-should-use - Suggests aliases for commands

### Tmux Configuration

Location: `tmux/.config/tmux/tmux.conf`

**Prefix**: `Ctrl+a` (not default `Ctrl+b`)

**Key Bindings**:
- `prefix + |` - Split horizontal
- `prefix + -` - Split vertical
- `prefix + hjkl` - Navigate panes (works with Neovim seamlessly)
- `prefix + r` - Reload config
- `prefix + I` - Install TPM plugins

**Plugins** (via TPM):
- tmux-resurrect - Save/restore sessions
- tmux-continuum - Auto-save sessions
- vim-tmux-navigator - Seamless Vim/tmux navigation
- tmux-yank - Copy to system clipboard
- tmux-fzf-url - Open URLs with FZF

## Development Workflows

### Go Development
```bash
# Standard workflow
go mod tidy && go mod download && go mod vendor  # Or just: mod
go test ./...
gotestsum                                         # Better test output

# Neovim has gopls configured for:
# - Auto-imports (goimports)
# - Formatting (gofumpt)
# - Linting (golangci-lint)
```

### Git Workflows
```bash
# Command line (with delta for better diffs)
git diff              # Side-by-side diff with syntax highlighting
git log --graph       # Visual commit graph

# In Neovim
<leader>gg            # Open lazygit (recommended)
:Git                  # Open fugitive
<leader>gr            # Reset current hunk (gitsigns)
```

### Kubernetes
```bash
k get pods            # kubectl alias
kctx                  # Switch context (kubectx)
kns                   # Switch namespace (kubens)
```

### File Navigation
```bash
# Shell
cd <partial-name>     # Zoxide smart jump
yy                    # Yazi file manager (supports preview, bulk ops)
fzf                   # Fuzzy find files

# Neovim
<C-p>                 # Telescope file finder
<leader>f             # Telescope live grep
<leader>e             # Neo-tree file explorer
```

## Important Notes

### Neovim Plugin Updates
Plugins are managed by Lazy.nvim. To update:
```vim
:Lazy sync            " Update all plugins
:Lazy clean           " Remove unused plugins
:Mason                " Manage LSP servers
```

### Tmux Plugin Management
After modifying tmux.conf or adding plugins:
```bash
tmux source ~/.config/tmux/tmux.conf
# Then press: prefix + I (to install new plugins)
```

### Stow Conflicts
If Stow reports conflicts (existing files), either:
1. Back up the existing file: `mv ~/.zshrc ~/.zshrc.backup`
2. Remove the existing file: `rm ~/.zshrc`
3. Use `--adopt` to have Stow take ownership: `stow --adopt zsh -t $HOME`

### Tool Dependencies
Some tools depend on others being installed:
- **Neovim LSPs**: Require language runtimes (Node, Go, Python, etc.)
- **Yazi preview**: Requires ffmpegthumbnailer, poppler, imagemagick
- **FZF**: Works best with fd and ripgrep (both installed)
- **Git delta**: Automatically configured as git pager

### macOS-Specific Configuration
- **AeroSpace**: Tiling window manager (requires accessibility permissions)
- **Raycast**: Spotlight replacement (disable Spotlight cmd+space first)
- **GPG/SSH**: Use macOS keychain for persistence

## Testing Changes

When modifying configurations:

**Zsh**:
```bash
source ~/.zshrc
```

**Tmux**:
```bash
tmux source ~/.config/tmux/tmux.conf
```

**Neovim**: Restart Neovim or `:source $MYVIMRC`

**AeroSpace**:
```bash
aerospace reload-config
```
