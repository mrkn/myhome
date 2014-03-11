function vim() {
  local vim old_IFS

  if [ -x /Applications/MacVim.app/Contents/MacOS/Vim ]; then
    vim=/Applications/MacVim.app/Contents/MacOS/Vim
  elif [ -x ~/Applications/MacVim.app/Contents/MacOS/Vim ]; then
    vim=~/Applications/MacVim.app/Contents/MacOS/Vim
  else
    vim=vim
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

alias l1='ls -1F'

alias .ckpd='cd ~/work/ckpd/primary'
alias .ckpd2='cd ~/work/ckpd/primary'

alias :e=vim
alias :q=exit
alias :qa=exit
