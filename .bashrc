# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# source ~/.fzf.bash

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"


# If not running interactively, don't do anything
export TERM="xterm-256color"
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|xterm-256color) color_prompt=yes;;
esac

source ~/config/.git-completion.bash
source ~/config/.git-prompt.sh

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	    color_prompt=yes
    else
	    color_prompt=
    fi
fi

function gettodo() {
   temp_out=`devtodo2`
   if [ -n "$temp_out" ]; then
       echo "-----------------------------------------"
       echo $temp_out
       echo "-----------------------------------------"
   fi
}

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[\033[01;36m\]|$(__git_ps1 " (%s)")\[\033[00m\]\$ '
    #PS1="\$(gettodo)\n"$PS1
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# # If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

# some more ls aliases
alias ls='ls -G'
alias ll='ls -GalF'
alias la='ls -GA'
alias l='ls -GCF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
export EDITOR="emacsclient"

# linux only
#export CLUTTER_IM_MODULE="ibus"
#export GTK_IM_MODULE="ibus"
#export QT4_IM_MODULE="ibus"
#export QT_IM_MODULE="ibus"
#export XMODIFIERS=@im=ibus
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export TERMINAL=lilyterm

#source ~/bin-dev/bin-dev.bashrc

#function 3_grep () {
#    grep -i -B 5 -A 10 $1 ~/Dropbox/10_ORG/workflowy.org
#}

function 3_grep () {
    rg -B5 -A10 $1 ~/Notebooks/Notes/
}

#function 3_grep() {
#    sqlite3 ~/Library/Containers/net.shinyfrog.bear/Data/Documents/Application\ Data/database.sqlite "select ZTEXT from ZSFNOTE where ZTEXT LIKE '%$1%';" | \grep --color -i "$1" -B 5 -A 10
#}

function 3_tcpdump() {
    interface=wlan0
    port=$1
    sudo tcpdump port $port -s 10000  -i $interface -w -
}

#linuxlogo
#cat ~/.motdnotes


#source ~/.bashrc.gopath
#source ~/.bashrc.alias

export HOMEBREW_GITHUB_API_TOKEN=

#hosts=$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | \grep -v "\[" | sort`;)

_ssh()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    hosts=$(cat ~/.ssh/config  | \grep '^Host ' | cut -d' ' -f2)
    COMPREPLY=( $(compgen -W "${hosts}" -f ${cur}) )
}
complete -F _ssh ssh
complete -F _ssh scp
complete -F _ssh mosh
complete -F _ssh pssh
complete -F _ssh pscp
complete -F _ssh pslurp
complete -F _ssh pnuke


source ~/config/.alias


#export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm



# added by travis gem
[ -f /Users/copyleft/.travis/travis.sh ] && source /Users/copyleft/.travis/travis.sh


# todo
alias todo="devtodo2"
#[ -z "$PS1" ] && return

#source ~/.bashrc.overwrite

#if [ -f $(brew --prefix)/etc/bash_completion ]; then
#. $(brew --prefix)/etc/bash_completion
#fi
eval `ssh-agent`

