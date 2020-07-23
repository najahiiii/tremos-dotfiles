[[ $- != *i* ]] && return

shopt -s checkwinsize
shopt -s cmdhist
shopt -s globstar
shopt -s histappend
shopt -s histverify

## Configure bash history.
export HISTFILE="$HOME/.bash_history"
export HISTSIZE=512
export HISTFILESIZE=512
export HISTCONTROL="ignoreboth"

## Prompt.
PROMPT_DIRTRIM=2
PS1="\\[\\e[0;32m\\]\\w\\[\\e[0m\\] \\[\\e[0;97m\\]\\$\\[\\e[0m\\] "
PS2='> '
PS3='> '
PS4='+ '

## Terminal title.
case "$TERM" in
	xterm*|rxvt*)
		PS1="\\[\\e]0;termux: \\w\\a\\]$PS1"
		;;
	*)
		;;
esac

## Colorful output & useful aliases for 'ls' and 'grep'.
if [ -x "$PREFIX/bin/dircolors" ] && [ -n "$LOCAL_PREFIX" ]; then
	if [ -f "$LOCAL_PREFIX/etc/dircolors.conf" ]; then
		eval "$(dircolors -b "$LOCAL_PREFIX/etc/dircolors.conf")"
	fi
fi

## Colored output.
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias dir='dir --color=auto'
alias l='ls --color=auto'
alias ls='ls --color=auto'
alias l.='ls --color=auto -d .*'
alias la='ls --color=auto -a'
alias ll='ls --color=auto -Fhl'
alias ll.='ls --color=auto -Fhl -d .*'
alias vdir='vdir --color=auto -h'

## Safety.
alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'
alias rm='rm -i'
