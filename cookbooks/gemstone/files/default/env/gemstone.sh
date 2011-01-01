# GemStone setup
export TZ=America/Los_Angeles
export GEMSTONE=/opt/gemstone/product
export PATH=$GEMSTONE/bin:/$PATH
export GEMSTONE_NRS_ALL=#dir:/opt/gemstone#log:/opt/gemstone/log/%N_%P.log
export GEMSTONE_EXE_CONF=/opt/gemstone/etc
export GEMSTONE_LOG=/opt/gemstone/log/seaside.log
export GEMSTONE_SYS_CONF=/opt/gemstone/etc/system.conf
export GEMSTONE_LOGDIR=/opt/gemstone/log
export GEMSTONE_NAME=seaside
export GEMSTONE_DATADIR=/opt/gemstone/data

alias gemtools="cd /opt/gemstone/gemtools && ./GemTools.sh"

alias gemstone="sudo /etc/init.d/gemstone"
alias netldi="sudo /etc/init.d/netldi"

alias gslist="gslist -cvl"
alias startnetldi="startnetldi -g -a glass -p 50378:50378"
alias startFastCGI="\$GEMSTONE/seaside/bin/runSeasideGems start"
alias startHyper="\$GEMSTONE/seaside/bin/startSeaside_Hyper 8008"
alias stopFastCGI="\$GEMSTONE/seaside/bin/runSeasideGems stop"
alias stopstone="stopstone seaside DataCurator swordfish"
alias startstone="startstone seaside"
alias topaz="topaz -l -T 50000"
