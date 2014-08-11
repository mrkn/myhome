function is_in_git_repo_p() {
  git ls-files &>/dev/null
}

function git_current_branch() {
  if is_in_git_repo_p; then
    local git_status="$(git status -bs | head -1)"
    echo ${git_status:3}
  else
    return 1
  fi
}

function pre_prompt_hook() {
  :
}

function rgb__() {
  local r=$1
  local g=$2
  local b=$3
  echo -n $((16 + $r * 36 + $g * 6 + $b))
}

PROMPT_COMMAND='last_exit_status=$?'

function build_primary_prompt() {
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

  local prompt_git_current_branch

  echo -n "${attr_reset}\$(pre_prompt_hook)${attr_reset}${attr_bold}${fg_color_gray241}\\u@\\h:\\w${attr_reset}"
  echo -n "\$(is_in_git_repo_p && echo -n \ [GIT BRANCH:'${fg_color_r3g3b0}'\$(git_current_branch)'${attr_reset}'])"
  echo -n " (\$(if [[ \$last_exit_status -gt 128 ]]; then echo SIGNAL \$((\$last_exit_status - 128)); else echo \$last_exit_status; fi))"
  echo -n "\\n${attr_bold}\$(if [[ \$last_exit_status = 0 ]]; then echo '${fg_color_r0g3b0}'; else echo '${fg_color_red}'; fi)\$${attr_reset} "
}

export PS1="$(build_primary_prompt)"

source $HOME/.bash_aliases

### Homebrew cask
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
