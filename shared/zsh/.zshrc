# ==============================================================================
# ~/.zshrc — João Victor
# Dotfiles compartilhado entre máquinas (Manjaro / Zorin)
# ==============================================================================

# ------------------------------------------------------------------------------
# PATH & Environment
# ------------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# SSH agent do Bitwarden
export SSH_AUTH_SOCK="$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"

# ------------------------------------------------------------------------------
# Oh My Zsh
# ------------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# IMPORTANTE: o array `plugins` precisa vir ANTES do source do oh-my-zsh.sh,
# senão nenhum plugin é carregado.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
)

source "$ZSH/oh-my-zsh.sh"

# ------------------------------------------------------------------------------
# Tool integrations
# ------------------------------------------------------------------------------
# nvm — só existe no Manjaro/Arch; no Zorin o caminho não existe, então o guard
# evita erro na inicialização do shell.
[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

# mise — gerenciador de versões (node, etc.)
eval "$(~/.local/bin/mise activate zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ------------------------------------------------------------------------------
# Aliases & Functions
# ------------------------------------------------------------------------------
# Deleta branches locais que não sejam main / staging / dev / develop
delete-branches() {
  for i in $(git branch | grep -v -E -w '(main|staging|dev|develop)$'); do
    git branch -D "$i"
  done
}
