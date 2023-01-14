# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH THEME
ZSH_THEME="robbyrussell"

# Execute some shell comands
source $ZSH/oh-my-zsh.sh

#This line loads the NVM to ZSH 
export NVM_DIR=~/.nvm
 [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Alias

# Fly.io
alias flyctl='$HOME/.fly/bin/flyctl'