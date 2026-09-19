#!/bin/bash

main() {
  __parse_git_branch() {
    git branch 2>/dev/null | grep '\*' | sed 's/* / (/;s/$/)/'
  }

  local -A v=(
    [RESET]="\[\033[0m\]"
    [GREEN]="\[\033[0;32m\]"
    [YELLOW]="\[\033[0;33m\]"
    [BRIGHT_BLUE]="\[\033[0;94m\]"
    [BRIGHT_MAGENTA]="\[\033[0;95m\]"
    [PASTEL_PURPLE]="\[\033[38;2;232;134;255m\]"

    [USER]="\u"
    [CWD]="\w"
    [DIR]="\W"
    [HOST]="\h"

    [GIT_BRANCH]="\$(__parse_git_branch)"
  )

  default() {
    PS1_BUILDER="[${v[USER]}@${v[HOST]} "
    PS1_BUILDER+="${v[DIR]}${v[GIT_BRANCH]}]"
    PS1_BUILDER+="$ "
    echo "$PS1_BUILDER"
  }

  two_line_full_cwd() {
    PS1_BUILDER="${v[BRIGHT_MAGENTA]}${v[USER]} "
    PS1_BUILDER+="${v[BRIGHT_BLUE]}${v[CWD]}"
    PS1_BUILDER+="${v[GREEN]}${v[GIT_BRANCH]}\n"
    PS1_BUILDER+="${v[RESET]}> "
    echo "$PS1_BUILDER"
  }

  one_line_full_cwd() {
    PS1_BUILDER="${v[PASTEL_PURPLE]}${v[USER]} "
    PS1_BUILDER+="${v[BRIGHT_BLUE]}${v[CWD]}"
    PS1_BUILDER+="${v[GREEN]}${v[GIT_BRANCH]} "
    PS1_BUILDER+="${v[RESET]}$ "
    echo "${PS1_BUILDER}"
  }

  PS1="$(one_line_full_cwd)"
  # PS1="$(two_line_full_cwd)"
  # PS1="$(default)"
}

main
