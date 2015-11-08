# Reload /etc/profile against tmux reorder PATH
[ -f /etc/profile ] && {
  PATH=""
  source /etc/profile
}

# Read ~/.bashrc
[ -f ~/.bashrc ] && source ~/.bashrc

# homebrew
if [ -d ~/.brew/bin ]; then
  export PATH=~/.brew/bin:$PATH
fi

# Docker Toolbox
if which docker-machine >/dev/null; then
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
eval "$(plenv init -)"
