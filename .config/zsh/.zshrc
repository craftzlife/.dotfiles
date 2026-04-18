# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the path to the p10k config file
POWERLEVEL9K_CONFIG_FILE=~/.config/zsh/.p10k.zsh
# Source Powerlevel10k theme
source ~/.config/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit the config file.
[[ ! -f $POWERLEVEL9K_CONFIG_FILE ]] || source $POWERLEVEL9K_CONFIG_FILE

# Plugins
autoload -U compinit; compinit
source ~/.config/zsh/pluggins/fzf-tab/fzf-tab.plugin.zsh
source ~/.config/zsh/pluggins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/pluggins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ls='ls --color=auto'
alias ll='ls -al'
alias la='ls -A'
alias l='ls -C'
alias cls='clear'
alias grep='grep --color=auto'
alias reload='source ~/.config/zsh/.zshrc'