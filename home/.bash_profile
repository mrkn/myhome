# Reload /etc/profile against tmux reorder PATH
[ -f /etc/profile ] && {
  PATH=""
  source /etc/profile
}

[ -f ~/.bashrc ] && source ~/.bashrc
export PATH=~/.rbenv/bin:~/bin:$PATH
eval "$(rbenv init -)"
