
# History settings
HISTFILE=~/.local/share/zsh/zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Share history between all sessions as soon as commands are entered
setopt SHARE_HISTORY
# Append to history file immediately, not when the shell exits
setopt INC_APPEND_HISTORY
# Do not record an event that was just recorded again.
setopt HIST_IGNORE_DUPS
# Expire duplicate entries first when trimming history.
setopt HIST_EXPIRE_DUPS_FIRST

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
typeset -U fpath  # prevent duplicates when re-sourcing
fpath=(~/.config/zsh/plugins/completions $fpath)
autoload -U compinit; compinit
source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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

# Git aliases
alias gst='git status'
alias gl='git log --graph'
alias gc='git commit'
alias ga='git add'
alias gcm='git commit --message'
alias gp="git push"

# Vim/nvim 
alias vi='nvim'

# Load zsh local configuration if it exists
[[ -f ~/.config/zsh/.zshrc.local ]] && source ~/.config/zsh/.zshrc.local
