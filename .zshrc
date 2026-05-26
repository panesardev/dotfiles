# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/rxcode/.zshrc'

PROMPT='
|> '
# PROMPT='
# %F{cyan}%~%f 
# |> '

autoload -Uz compinit
compinit

alias ls="ls -lhFA"

alias install="yay -S"
alias update="yay -Syu"
alias remove="yay -Rns"
alias search="yay -Ss"
alias list="pacman -Qqe"


fastfetch

# End of lines added by compinstall
