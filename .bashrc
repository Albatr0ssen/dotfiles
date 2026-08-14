#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

for i in "$HOME/.bashrc.d"/*.sh; do
  if [ -r "$i" ]; then
    # shellcheck source=/dev/null
    . "$i"
  fi
done
unset i

export EDITOR=nvim

bind '"\C-h": backward-kill-word'

alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias lg='lazygit'
alias ff='fastfetch'

alias tmux-session='tmux new-session -A -s'
alias pptx2pdf='soffice --headless --convert-to pdf'
alias source-bashrc='source $HOME/.bashrc'
alias cups-webui='xdg-open http://localhost:631'

ls_latest() {
  ls -laht -I "." -I ".." "$@" | head -8
}
alias latest='ls_latest'

alias ntp-status='timedatectl timesync-status'

if [ -d "$HOME/.local/bin" ]; then
  PATH="$PATH:$HOME/.local/bin"
fi
