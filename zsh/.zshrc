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

# Sublime Text aliases
alias s="subl -n ."

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

# Setup Amazon EC2 Command-Line Tools
#export EC2_HOME=~/.ec2
#export PATH=$PATH:$EC2_HOME/bin
#export EC2_PRIVATE_KEY=`ls $EC2_HOME/pk-*.pem`
#export EC2_CERT=`ls $EC2_HOME/cert-*.pem`
#export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/
#export AWS_CREDENTIALS_FILE=~/.ec2/aws-credentials
#export PERL5LIB=/usr/bin

# Hadoop
alias hadoop-start="/usr/local/Cellar/hadoop/1.0.3/bin/start-all.sh"
alias hadoop-stop="/usr/local/Cellar/hadoop/1.0.3/bin/stop-all.sh"

# Autojump
if [ -f `brew --prefix`/etc/autojump ]; then
  . `brew --prefix`/etc/autojump
fi

# MacPorts Installer addition on 2009-12-01_at_22:52:56: adding an appropriate PATH variable for use with MacPorts.
export PATH=$PATH:/opt/local/bin:/opt/local/sbin
# Finished adapting your PATH environment variable for use with MacPorts.

[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"

# Git aliases
alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

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