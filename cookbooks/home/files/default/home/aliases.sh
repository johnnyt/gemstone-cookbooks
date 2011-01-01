alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
alias grep='grep --color=auto'
alias c="cd "
alias ..="cd .."
alias cd..="cd .."
alias f="find . -name"
alias h="history"
alias gh="history | grep"
alias gg="gem list | grep"

alias ngx="sudo /etc/init.d/nginx"
alias res='touch tmp/restart.txt'

alias itop="sudo iftop"

alias tf='tail -f -n 100'
alias t500='tail -n 500'
alias t1000='tail -n 1000'
alias t2000='tail -n 2000'

# rubygems shortcuts (http://stephencelis.com/archive/2008/6/bashfully-yours-gem-shortcuts)
alias gems='cd $(gem env gemdir)/gems'

gemlite() {
  gem install $1 --no-rdoc --no-ri
}

# Get rid of Wuff Wuff
alias screen='TERM=screen screen'
alias s="start_screen"

# grep for a process
function gp {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# Rails
alias ss="ruby script/server"
alias sc="ruby script/console"

# Git
alias g='git '
alias gst='git status'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbn='git checkout -b '
alias gma='git checkout master'
alias gco='git checkout'
alias gca='git commit -v -a'
alias gc='git commit -v'

# editing shortcuts
alias e='emacs'
alias ep='e ~/.bashrc'
alias v='vim'
alias vp='v ~/.bashrc'
alias sp='source ~/.bashrc'
