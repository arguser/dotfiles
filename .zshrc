#
# ~/.zshrc
#

#History
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000

#Dircolors
eval `dircolors -b`

#Editor
export EDITOR="vim"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '
alias ls='ls --color=auto'
alias ll="ls --color -lh"
alias reboot="sudo reboot"
alias poweroff="sudo poweroff"
alias halt="sudo halt"

case $TERM in
    *xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
precmd () { print -Pn "\e]0;[%n@%M][%~]%#\a" }
preexec () { print -Pn "\e]0;[%n@%M][%~]%# ($1)\a" }
;;
    screen)
     precmd () {
print -Pn "\e]83;title \"$1\"\a"
print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a"
}
preexec () {
print -Pn "\e]83;title \"$1\"\a"
print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a"
}
;;
esac

autoload -U compinit promptinit colors && colors
compinit
promptinit

PROMPT="%{$fg[blue]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%1~ %{$reset_color%}>> "

setopt completealiases
bindkey -v

bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
# for rxvt
bindkey "\e[7~" beginning-of-line # Home
bindkey "\e[8~" end-of-line # End

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

#tuff to make my life easier

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# cd not select parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd
