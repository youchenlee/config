# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
. ~/.profile

# User specific environment and startup programs

#PATH=$PATH:$HOME/bin


#PATH=$HOME/myprefix/bin:$HOME/bin:/home/y/bin:/home/y/bin64:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:\
#/usr/X11R6/bin:/usr/local/sbin

#export PATH
#if [ -n "$PS1" ]; then
#  PS1="\h \t \w \$ "
#  fi
#fi


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


# The next line updates PATH for the Google Cloud SDK.
if [ -f /Users/copyleft/Downloads/google-cloud-sdk/path.bash.inc ]; then
  source '/Users/copyleft/Downloads/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Users/copyleft/Downloads/google-cloud-sdk/completion.bash.inc ]; then
  source '/Users/copyleft/Downloads/google-cloud-sdk/completion.bash.inc'
fi
