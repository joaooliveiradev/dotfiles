# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH THEME
ZSH_THEME="robbyrussell"

# Execute some shell comands
source $ZSH/oh-my-zsh.sh

# Start NVM
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /usr/share/nvm/init-nvm.sh

# Start ASDF
. /home/joaooliveiradev/dev/asdf-vm/pkg/asdf-vm/opt/asdf-vm/asdf.sh

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
)

# Alias

# Fly.io
alias flyctl="$HOME/.fly/bin/flyctl"

# bun completions
[ -s "/home/joaooliveiradev/.bun/_bun" ] && source "/home/joaooliveiradev/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Deletar branches diferente de main, staging e dev / develop
function delete-branches () {
  for i in $(git branch | grep -v -E -w '(main|staging|dev|develop)$'); do
    git branch -D "$i"
  done
}
