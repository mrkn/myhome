# Reload /etc/profile against tmux reorder PATH
[ -f /etc/profile ] && {
  PATH=""
  source /etc/profile
}

# rbenv
[ -f ~/.bashrc ] && source ~/.bashrc
export PATH=~/.rbenv/bin:~/bin:$PATH
eval "$(rbenv init -)"

# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
  export PATH=${PYENV_ROOT}/bin:$PATH
  eval "$(pyenv init -)"
fi
