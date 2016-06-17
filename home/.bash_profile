# Reload /etc/profile against tmux reorder PATH
[ -f /etc/profile ] && {
  PATH=""
  source /etc/profile
}

# Read ~/.bashrc
[ -f ~/.bashrc ] && source ~/.bashrc

# homebrew
HOMEBREW_PREFIX=/opt/brew
if [ -d $HOMEBREW_PREFIX/bin ]; then
  export PATH=$HOMEBREW_PREFIX/bin:$PATH
fi

# Docker Toolbox
if which docker-machine >/dev/null; then
  case $(docker-machine status default) in
    Stopped)
      docker-machine start default
      ;;
  esac
  eval "$(docker-machine env default)"
fi

# rbenv
export PATH=~/.rbenv/bin:~/bin:$PATH
eval "$(rbenv init -)"

# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
  export PATH=${PYENV_ROOT}/bin:$PATH
  eval "$(pyenv init -)"
fi

# plenv
export PATH="$HOME/.plenv/bin:$PATH"
which plenv &>/dev/null && eval "$(plenv init -)"

# embulk
if [ -d ~/.embulk/bin ]; then
  export PATH="$HOME/.embulk/bin:$PATH"
fi
