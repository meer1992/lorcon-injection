#!/usr/bin/sudo /bin/bash

IFACE=wlp1s0

if [ $# -ne 2 ]; then
    echo "Usage: ./setup_inject.sh <channel> {HT20|HT40-|HT40+}"
    exit
fi

lsmod | grep iwl >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Reloading iwl driver"
    modprobe -r iwldvm iwlwifi mac80211 cfg80211
    modprobe iwlwifi debug=0x40000
    ifconfig $IFACE >/dev/null 2>&1
    while [ $? -ne 0 ]
    do
        ifconfig $IFACE >/dev/null 2>&1
    done
fi

# create mon0 if not exist
ip link show mon0 >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Creating monitor interface"
    iw dev $IFACE interface add mon0 type monitor
    ip link show mon0 >/dev/null 2>&1
    while [ $? -ne 0 ]
    do
        ip link show mon0 >/dev/null 2>&1
    done
fi

# activate mon0 if not
ifconfig mon0 >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Activating monitor interface"
    ifconfig mon0 up
    ifconfig mon0 >/dev/null 2>&1
    while [ $? -ne 0 ]
    do
        ifconfig mon0 >/dev/null 2>&1
    done
fi

iw $IFACE info >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Deleting managed interface"
    iw $IFACE del
fi

# set channel and frequency
channel=$(./channel.sh)
if [ "$channel" -ne $1 ]; then
    echo "Setting channel and frequency"
    iw mon0 set channel $1 $2
    channel=$(./channel.sh)
    while [ "$channel" -ne 1 ]
    do
        :
    done
fi
echo "Setup done"

