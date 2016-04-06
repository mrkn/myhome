function vim() {
  local vim old_IFS

  if [ -x /Applications/MacVim.app/Contents/MacOS/Vim ]; then
    vim=/Applications/MacVim.app/Contents/MacOS/Vim
  elif [ -x ~/Applications/MacVim.app/Contents/MacOS/Vim ]; then
    vim=~/Applications/MacVim.app/Contents/MacOS/Vim
  else
    vim=/usr/bin/vim
  fi

  if [ $# -eq 1 ]; then
    old_IFS="$IFS"
    IFS=:
    set -- $@
    IFS="$old_IFS"
    if [ -n "$2" ]; then
      $vim +$2 "$1"
    else
      $vim "$1"
    fi
  else
    $vim "$@"
  fi
}

alias bi='bundle install'
alias be='bundle exec'

case "${OSTYPE}" in
  darwin*)
    alias ls='ls -GF'
    ;;
  linux*)
    alias ls='ls --color -F'
    ;;
esac

alias l1='ls -1'
alias ll='ls -l'
alias la='ls -a'
alias lla='ll -a'

alias .ckpd='cd ~/work/ckpd/primary'
alias .ckpd2='cd ~/work/ckpd/primary'

alias :e=vim
alias :q=exit
alias :qa=exit
