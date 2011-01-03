# Detect operating system
PLATFORM="`uname -sm | tr ' ' '-'`"

echo "[Info] Setting up shared memory"
# Ref: http://developer.postgresql.org/pgdocs/postgres/kernel-resources.html
# Ref: http://www.idevelopment.info/data/Oracle/DBA_tips/Linux/LINUX_8.shtml

case "$PLATFORM" in
    Linux-x86_64)
    # use TotalMem: kB because Ubuntu doesn't have Mem: in Bytes
    totalMemKB=`awk '/MemTotal:/{print($2);}' /proc/meminfo`
    totalMem=$(($totalMemKB * 1024))
    # Figure out the max shared memory segment size currently allowed
    shmmax=`cat /proc/sys/kernel/shmmax`
    # Figure out the max shared memory currently allowed
    shmall=`cat /proc/sys/kernel/shmall`
    ;;
    Darwin-i386)
    totalMem="`sysctl hw.memsize | cut -f2 -d' '`"
    # Figure out the max shared memory segment size currently allowed
    shmmax="`sysctl kern.sysv.shmmax | cut -f2 -d' '`"
    # Figure out the max shared memory currently allowed
    shmall="`sysctl kern.sysv.shmall | cut -f2 -d' '`"
    ;;
    *)
    echo "[Error] Can't determine operating system. Check script."
    exit 1
    ;;
esac
totalMemMB=$(($totalMem / 1048576))
shmmaxMB=$(($shmmax / 1048576))
shmallMB=$(($shmall / 256))

# Print current values
echo "  Total memory available is $totalMemMB MB"
echo "  Max shared memory segment size is $shmmaxMB MB"
echo "  Max shared memory allowed is $shmallMB MB"

# Figure out the max shared memory segment size (shmmax) we want
# Use 75% of available memory but not more than 2GB
shmmaxNew=$(($totalMem * 3/4))
[ $shmmaxNew -gt 2147483648 ] && shmmaxNew=2147483648
shmmaxNewMB=$(($shmmaxNew / 1048576))

# Figure out the max shared memory allowed (shmall) we want
# The MacOSX default is 4MB, way too small
# The Linux default is 2097152 or 8GB, so we should never need this
# but things will certainly break if it's been reset too small
# so ensure it's at least big enough to hold a fullsize shared memory segment
shmallNew=$(($shmmaxNew / 4096))
[ $shmallNew -lt $shmall ] && shmallNew=$shmall
shmallNewMB=$(($shmallNew / 256))

# Increase shmmax if appropriate
if [ $shmmaxNew -gt $shmmax ]; then
    echo "[Info] Increasing max shared memory segment size to $shmmaxNewMB MB"
    [ $PLATFORM = "Darwin-i386" ] && sudo sysctl -w kern.sysv.shmmax=$shmmaxNew
    [ $PLATFORM = "Linux-x86_64" ] && sudo bash -c "echo $shmmaxNew > /proc/sys/kernel/shmmax"
else
    echo "[Info] No need to increase max shared memory segment size"
fi

# Increase shmall if appropriate
if [ $shmallNew -gt $shmall ]; then
    echo "[Info] Increasing max shared memory allowed to $shmallNewMB MB"
    [ $PLATFORM = "Darwin-i386" ] && sudo sysctl -w kern.sysv.shmall=$shmallNew
    [ $PLATFORM = "Linux-x86_64" ] && sudo bash -c "echo $shmallNew > /proc/sys/kernel/shmall"
else
    echo "[Info] No need to increase max shared memory allowed"
fi

# At this point, shared memory settings contain the values we want, 
# put them in sysctl.conf so they are preserved.
if [[ ! -f /etc/sysctl.conf || `grep -sc "kern.*.shm" /etc/sysctl.conf` -eq 0 ]]; then
    case "$PLATFORM" in
        Linux-x86_64)
        echo "# kernel.shm* settings added by MagLev installation" > /tmp/sysctl.conf.$$
        echo "kernel.shmmax=`cat /proc/sys/kernel/shmmax`" >> /tmp/sysctl.conf.$$
        echo "kernel.shmall=`cat /proc/sys/kernel/shmall`" >> /tmp/sysctl.conf.$$
        ;;
        Darwin-i386)
        # On Mac OS X Leopard, you must have all five settings in sysctl.conf
        # before they will take effect.
        echo "# kern.sysv.shm* settings added by MagLev installation" > /tmp/sysctl.conf.$$
        sysctl kern.sysv.shmmax kern.sysv.shmall kern.sysv.shmmin kern.sysv.shmmni \
        kern.sysv.shmseg  | tr ":" "=" | tr -d " " >> /tmp/sysctl.conf.$$
        ;;
        *)
        echo "[Error] Can't determine operating system. Check script."
        exit 1
        ;;
    esac
    #
    echo "[Info] Adding the following section to /etc/sysctl.conf"
    cat /tmp/sysctl.conf.$$
    sudo bash -c "cat /tmp/sysctl.conf.$$ >> /etc/sysctl.conf"
    /bin/rm -f /tmp/sysctl.conf.$$
else
    echo "[Info] The following shared memory settings already exist in /etc/sysctl.conf"
    echo "To change them, remove the following lines from /etc/sysctl.conf and rerun this script"
    grep "kern.*.shm" /etc/sysctl.conf
fi
