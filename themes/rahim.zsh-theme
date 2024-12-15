function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return
  
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is anything staged?
  if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
  echo $(current_branch || echo "(no branch)")
}

function my_return_code_color() {
  echo "%(?.$ZSH_THEME_PROMPT_RETURNCODE_SUCCESS_PREFIX.$ZSH_THEME_PROMPT_RETURNCODE_ERROR_PREFIX)"
}

function my_aws_prompt() {
  # the clumsy looking conditional is because we care whether the AWS_PROFILE
  # has been exported, not just set in the current context
  if [[ -n $(printenv AWS_PROFILE) ]]; then
    AWS_STATUS="$AWS_PROFILE"
    echo "$ZSH_THEME_AWS_PROMPT_PREFIX$AWS_STATUS$ZSH_THEME_AWS_PROMPT_SUFFIX"
  fi
}

function prompt_hostname() {
  [ -n "$HOST" ] && echo "$HOST:";
}

function prompt_symbol() {
  if [ "$(uname -s)" = "Darwin" ] && [ "$(uname -m)" = "x86_64" ]; then
    echo "⟁"
  else
    echo "ᐅ"
  fi
}

PROMPT=$'%{$fg_bold[blue]%}$(prompt_hostname)${PWD/#$HOME/~} %{$reset_color%}$(my_aws_prompt)$(my_git_prompt) %{$(my_return_code_color)%}$(prompt_symbol)%{$reset_color%} '

ZSH_THEME_PROMPT_RETURNCODE_ERROR_PREFIX="%{$fg_bold[red]%}"
ZSH_THEME_PROMPT_RETURNCODE_SUCCESS_PREFIX="%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}[%{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[white]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✕"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[white]%}]%{$reset_color%}"

ZSH_THEME_AWS_PROMPT_PREFIX="%{$fg_bold[white]%}[%{$fg_bold[yellow]%}"
ZSH_THEME_AWS_PROMPT_SUFFIX="%{$fg_bold[white]%}]%{$reset_color%}"
