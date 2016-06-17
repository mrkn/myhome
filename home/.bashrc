### Locale

export LANG=en_US.UTF-8

### Network

function intra_ip() {
  ifconfig | grep 'inet \(10\.\|172\.\(1[6-9]\|2[0-9]\|3[01]\)\.\|192\.168\.\)' | tail -1 | cut -d' ' -f2
}

### Prompt
function is_in_git_repo_p() {
  git ls-files &>/dev/null
}

function git_current_branch() {
  local ref=$(git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

function rgb__() {
  local r=$1
  local g=$2
  local b=$3
  echo -n $((16 + $r * 36 + $g * 6 + $b))
}

function set_prompt() {
  # store last command into history
  history -a

  case $TERM in
  *256color)
    local attr_reset='\[\e[0m\]'
    local attr_bold='\[\e[1m\]'
    local attr_underline='\[\e[4m\]'
    local attr_blink='\]\e[5m\]'

    local fg_color_red='\[\e[31m\]'
    local fg_color_r3g3b0='\[\e[38;5;'$(rgb__ 3 3 0)'m\]'
    local fg_color_r0g3b0='\[\e[38;5;'$(rgb__ 0 3 0)'m\]'
    local fg_color_gray241='\[\e[38;5;241m\]'
    ;;
  esac

  PS1=""

  # timestamp
  local cols=$(tput cols)
  local separator=$(eval "printf -- -%.0s {1..$(($cols - 22))}")
  PS1+="\n${attr_reset}${fg_color_gray241}[\$(date +'%Y-%m-%d %H:%M:%S')] ${separator}${attr_reset}"

  # username and hostname
  PS1+="\n${attr_reset}${attr_bold}${fg_color_gray241}\\u@\\h:\\w${attr_reset}"

  # git repository information
  is_in_git_repo_p && \
    PS1+=" [GIT BRANCH:${fg_color_r3g3b0}$(git_current_branch)${attr_reset}]"

  # previous process status
  if [[ $last_exit_status -gt 128 ]]; then
    PS1+=" (SIGNAL $(($last_exit_status - 128)))"
  else
    PS1+=" ($last_exit_status)"
  fi

  # colored prompt mark
  local prompt_color
  if [[ $last_exit_status == 0 ]]; then
    prompt_color=${fg_color_r0g3b0}
  else
    prompt_color=${fg_color_red}
  fi
  PS1+="\\n${attr_bold}${prompt_color}\$${attr_reset} "
}

PROMPT_COMMAND='set_prompt'

### Absolute path cd command in history
### See http://inaz2.hatenablog.com/entry/2014/12/11/015125
if [[ -n "$PS1" ]]; then
  function cd() {
    command cd "$@"
    local s=$?
    if [[ ($s -eq 0) && (${#FUNCNAME[*]} -eq 1) ]]; then
      history -s cd $(printf "%q" "$PWD")
    fi
    return $s
  }
fi

### LESS and LV

export LV='-c'
export LESS='-R'

if test -x $(which src-hilite-lesspipe.sh); then
  alias hl=src-hilite-lesspipe.sh
  export LESSOPEN="| src-hilite-lesspipe.sh %s"
else
  alias hl=cat
fi

function lvs() {
  local file="$1"
  shift
  hl "$file" | lv "$@"
}

### Direnv

which direnv &>/dev/null && eval "$(direnv hook bash)"

# hack for direnv bug
PROMPT_COMMAND="last_exit_status=\$?; $PROMPT_COMMAND"

### Aliases
source $HOME/.bash_aliases

### Homebrew cask
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### CUDA Toolkit 7

if [ -d /usr/local/cuda ]; then
  export PATH=/usr/local/cuda/bin:$PATH
  export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH
fi

### Added by torch-dist
if [ -d ~/torch/install ]; then
  export PATH=~/torch/install/bin:$PATH
  export DYLD_LIBRARY_PATH=~/torch/install/lib:$DYLD_LIBRARY_PATH
fi
