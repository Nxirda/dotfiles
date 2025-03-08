#
# ~/.bashrc
#

neofetch

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### ARCHIVE EXTRACTION
# usage: ex file
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Ask to confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# Convenience aliases
alias lock='hyprlock'
alias off='poweroff'
alias shutdown='poweroff'
alias yeet="rm -Rf"
alias vi='vim'
alias open='xdg-open'

if [ -f /etc/bash_completion ]; then
   . /etc/bash_completion
fi

#show current branch when working in git
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1='$(parse_git_branch)\[\033[1m\][\h \W]\$\[\033[00m\] '

# Settings exports, this is mainly for tmux/vim to correctly show colors
export TERM=xterm-256color
