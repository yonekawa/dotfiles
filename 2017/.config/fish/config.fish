# Exports
set -x LANG "ja_JP.UTF-8"
set -x PATH "$HOME/bin" $PATH

set -x COREUTILS_ROOT (brew --prefix coreutils)
set -x PATH "$COREUTILS_ROOT/libexec/gnubin" $PATH

set -x GOPATH "$HOME"
set -x PATH "$HOME/.goenv/bin" $PATH

set -x PATH "$GOPATH/src/github.com/flutter/flutter/bin" $PATH

# Alias
alias ls='ls --color=auto -h'
alias ks='ls'
alias be='bundle exec'
alias gti='git'
alias find=gfind
alias xargs=gxargs

# Functions
function cd
  builtin cd $argv
  ls -la
end

function peco
  command peco --layout=bottom-up $argv
end

function fish_user_key_bindings
  bind \cl peco_select_ghq_repository
  bind \cr 'peco_select_history (commandline -b)'
  bind \cx\ck peco_kill
# bind \cj peco_recentd
  bind \cb peco_switch_branch
end

tmux rename-window 'HOME'

function pwd_chaned --on-variable PWD
  set current_path current_path=(pwd | sed -e s/\ /_/g)
  set current_dir (basename {$current_path})
  if [ $current_dir = $USER ]
    tmux rename-window 'HOME'
  else
    tmux rename-window {$current_dir}
  end
end
