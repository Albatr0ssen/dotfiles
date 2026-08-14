#!/bin/bash

LG_CONFIG_DIR="$HOME/.config/lazygit"

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

(
source /usr/share/bash-completion/completions/git
__git_complete dotfiles __git_main
)


__lg_dotfiles() {
  lazygit \
    --git-dir="${HOME}/.dotfiles/" \
    --work-tree="${HOME}" \
    --ucf="${LG_CONFIG_DIR}/config.yml,${LG_CONFIG_DIR}/dotfiles.yml"
}

alias lg-dotfiles='__lg_dotfiles'
