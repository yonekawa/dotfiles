# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cloud"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew extract osx node npm ruby rails3 autojump)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:$PATH
if [ -d "$HOME/bin" ] ; then
  export PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/node_modules/.bin" ] ; then
  export PATH="$HOME/node_modules/.bin:$PATH"
fi

alias ls='ls --color=auto -h'
alias ks='ls'
alias screen='screen -r'
alias brewup='brew update && brew upgrade'
alias be='bundle exec'

##
# git completion
# wget -O ~/.git-completion.bash "http://git.kernel.org/?p=git/git.git;a=blob_plain;f=contrib/completion/git-completion.bash;h=893b7716cafa4811d237480a980140d308aa20dc;hb=01b97a4cb60723d18b437efdc474503d2a9dd384"
##
if [ -f "$HOME/.git-completion.bash" ]; then
  autoload bashcompinit
  bashcompinit
  source $HOME/.git-completion.bash
fi

if [ $TERM = xterm-color ];then
    preexec() {
        echo -ne "\ek#${1%% *}\e\\"
    }
    precmd() {
        echo -ne "\ek$(basename $(pwd))\e\\"
    }
fi

if [[ -f ~/.nvm/nvm.sh ]]; then
  source ~/.nvm/nvm.sh

  if which nvm >/dev/null 2>&1 ;then
    _nodejs_use_version="v0.4.12"
    if nvm ls | grep -F -e "${_nodejs_use_version}" >/dev/null 2>&1 ;then
      nvm use "${_nodejs_use_version}" >/dev/null
      export NODE_PATH=${NVM_PATH}_modules${NODE_PATH:+:}${NODE_PATH}
    fi
    unset _nodejs_use_version
  fi
fi

if [[ -d /usr/local/Cellar/android-sdk ]]; then
  export ANDROID_SDK_ROOT=/usr/local/Cellar/android-sdk/r18
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

if [[ -f ~/Library/Trigger\ Toolkit/forge ]]; then
  echo "aa"
  alias forge="~/Library/Trigger\ Toolkit/forge"
fi

export USE_BUNDLER=1
