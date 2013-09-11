# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="robbyrussell"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(rails git ruby osx)

source $ZSH/oh-my-zsh.sh

# pyenv setup
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# Customize to your needs...
export PATH=/Library/PostgreSQL/9.1/bin:$PATH
export PATH=$HOME/bin:$PATH:/opt/local/bin:~/opt/bin:~/.gem/ruby/1.8/bin:
#export PATH=/usr/bin:/sw/bin:/sw/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/usr/X11R6/bin:~/opt/bin
export PATH=$PATH:/usr/local/Cellar/mongodb/2.0.4-x86_64/bin
export MANPATH=$MANPATH:/opt/local/share/man
export INFOPATH=$INFOPATH:/opt/local/share/info
export CLASSPATH=$CLASSPATH:~/Development/java/junit-4.8.2.jar:~/Development/java/mongo-2.3.jar:~/Development/java/GroboUtils-5/lib/GroboUtils-5-core.jar:~/Development/java/mysql-connector-java-5.1.15/mysql-connector-java-5.1.15-bin.jar
export NODE_PATH=/Users/Chetan/opt/lib/node:$NODE_PATH

# Terminal aliases and functions
alias o="open"
function c() { cd "$@"; ls; }

# Shortcut aliases
alias chrome-dev="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary --allow-file-access-from-files"

# MacVim aliases
#alias v="mvim"

# ChetanSurpur.com aliases
alias chetansurpur="ssh root@chetansurpur.com"

# Python stuff
export PYTHONPATH=$PYTHONPATH:/Library/Python/2.6/site-packages:/opt/local/Library/Frameworks/Python.framework/Versions/2.6/lib/python2.6/site-packages/

# MySQL aliases
alias mysql-start="sudo /opt/local/etc/LaunchDaemons/org.macports.mysql5/mysql5.wrapper start"
alias mysql-stop="sudo /opt/local/etc/LaunchDaemons/org.macports.mysql5/mysql5.wrapper stop"

# Mac aliases
alias ql="qlmanage -p"

# Postgres
export PGDATA=/Library/PostgreSQL/9.1/data

# Octave
export GNUTERM=x11

# Setup Amazon EC2 Command-Line Tools
export JAVA_HOME="$(/usr/libexec/java_home)"
export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"
export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"

# EC2 aliases
alias ec2-linguist="ssh -i ~/.ec2/linguist.pem ec2-user@ec2-54-226-204-77.compute-1.amazonaws.com"

# Hadoop
alias hadoop-start="/usr/local/Cellar/hadoop/1.0.3/bin/start-all.sh"
alias hadoop-stop="/usr/local/Cellar/hadoop/1.0.3/bin/stop-all.sh"

# Fasd
eval "$(fasd --init posix-alias zsh-hook)"

# Sublime Text aliases
alias s="subl -n ."

# MacPorts Installer addition on 2009-12-01_at_22:52:56: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"

# Git aliases
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gpr="git pull --rebase"
alias gpu="git push"

# Go
export GOPATH=~/Development/go

# NuPIC
export NUPIC=$HOME/Development/nupic
export NTA=$HOME/Development/nta/eng
export BUILDDIR=/tmp/ntabuild
export MK_JOBS=3
source $NUPIC/env.sh

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# nvm
. ~/.nvm/nvm.sh
[ -s "/Users/chetansurpur/.scm_breeze/scm_breeze.sh" ] && source "/Users/chetansurpur/.scm_breeze/scm_breeze.sh"


# Utilities

function acks {
    if [ -z "$1" -o -z "$2" ]; then
        echo "Usage: substitue FROM_STRING TO_STRING [OPTION]..."
        echo
        echo "Replace all occurances of FROM_STRING (a sed-compatible regular"
        echo "expression) with TO_STRING in all files for which ack-grep matches"
        echo "FROM_STRING."
        echo
        echo "Any additional options are passed directly to ack-grep (e.g.,"
        echo " --type=html would only run the substitution on html files)." 
        return 1
    fi
    # Escape forward slashes for sed
    FROM_STRING=${1/\//\\/}
    TO_STRING=${2/\//\\/}
    shift 2
    ack -l --print0 "$@" "$FROM_STRING" | xargs -0 -n 1 sed -i -e "s/$FROM_STRING/$TO_STRING/g"
}