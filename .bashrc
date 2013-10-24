alias ls="ls -G"

##
# Your previous /Users/copyleft/.bash_profile file was backed up as /Users/copyleft/.bash_profile.macports-saved_2013-02-03_at_16:57:34
##

# MacPorts Installer addition on 2013-02-03_at_16:57:34: adding an appropriate PATH variable for use with MacPorts.
export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:/opt/local/lib/php/pear/bin:$PATH:~/bin:~/.cask/bin/
# Finished adapting your PATH environment variable for use with MacPorts.

export TERM=xterm-256color

3_get_note()
{
    grep -i --color -A 5 -B 5 $1  ~/Dropbox/10_ORG/Notebook.org.txt
}

alias grep="grep --color"

export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"

alias et="emacs ~/Cloud\ Drive/10_ORG/TODO.org.txt"
alias em="emacs ~/Cloud\ Drive/10_ORG/emacs.org.txt"

export EDITOR=emacs
alias e="emacs"
