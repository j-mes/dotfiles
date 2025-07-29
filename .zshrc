############################################################
# Zsh Configuration File
# Loads Oh My Zsh, plugins, themes, and custom tools
############################################################

# Set Oh My Zsh directory
export ZSH=~/.oh-my-zsh
# Set custom Oh My Zsh config directory
ZSH_CUSTOM=~/.config/oh-my-zsh
# Set Zsh theme
ZSH_THEME="robbyrussell"
# Enable plugins
plugins=(git)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Initialize Starship prompt
eval "$(starship init zsh)"

# Load fzf key bindings and completion if installed
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load custom environment variable exports
[ -f "$ZSH_CUSTOM/exports.zsh" ] && source "$ZSH_CUSTOM/exports.zsh"
