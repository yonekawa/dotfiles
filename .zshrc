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
plugins=(git brew extract osx node svn)

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
alias brewupdate='brew update && brew upgrade'

##
# git completion
# wget -O ~/.git-completion.bash "http://git.kernel.org/?p=git/git.git;a=blob_plain;f=contrib/completion/git-completion.bash;h=893b7716cafa4811d237480a980140d308aa20dc;hb=01b97a4cb60723d18b437efdc474503d2a9dd384"
##
if [ -f "$HOME/.git-completion.bash" ]; then
  autoload bashcompinit
  bashcompinit
  source $HOME/.git-completion.bash
fi

##
#  Display cwd or command running.
#  Comment out condition because $TERM returns 'xterm-color'.
##
#if [ "$TERM" = "screen" ]; then
    chpwd () { echo -n "_`dirs`\\" }
    preexec() {
        emulate -L zsh
        local -a cmd; cmd=(${(z)2})
        case $cmd[1] in
            fg)
                if (( $#cmd == 1 )); then
                    cmd=(builtin jobs -l %+)
                else
                    cmd=(builtin jobs -l $cmd[2])
                fi
                ;;
            %*)
                cmd=(builtin jobs -l $cmd[1])
                ;;
            cd)
                if (( $#cmd == 2)); then
                    cmd[1]=$cmd[2]
                fi
                ;&
                *)
    echo -n "k$cmd[1]:t\\"
    return
    ;;
    esac

    local -A jt; jt=(${(kv)jobtexts})

    $cmd >>(read num rest
        cmd=(${(z)${(e):-\$jt$num}})
        echo -n "k$cmd[1]:t\\") 2>/dev/null
    }
    chpwd
#fi
#if [ "$TERM" = "screen" ]; then
    precmd(){
        screen -X title $(basename $(print -P "%~"))
    }
#fi