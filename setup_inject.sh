#!/usr/bin/sudo /bin/bash

if [ $# -ne 4 ]; then
    echo "Usage: ./setup_inject.sh <interface> <monitor_iface> <channel> {HT20|HT40-|HT40+}"
    exit
fi

IFACE=$1
MONITOR=$2
CHANNEL=$3
MODE=$4

lsmod | grep iwl >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Reloading iwl driver"
    modprobe -r iwldvm iwlwifi mac80211 cfg80211
    modprobe iwlwifi debug=0x40000
    #ifconfig $IFACE >/dev/null 2>&1
    ip link show $IFACE >/dev/null 2>&1
    while [ $? -ne 0 ]
    do
        #ifconfig $IFACE >/dev/null 2>&1
        ip link show $IFACE >/dev/null 2>&1
    done
fi

# create $MONITOR if not exist
ip link show $MONITOR >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Creating monitor interface"
    iw dev $IFACE interface add $MONITOR type monitor
    ip link show $MONITOR >/dev/null 2>&1
    while [ $? -ne 0 ]
    do
        ip link show $MONITOR >/dev/null 2>&1
    done
fi

# activate $MONITOR if not
#ifconfig $MONITOR >/dev/null 2>&1
#if [ $? -ne 0 ]; then
ip link show $MONITOR | grep -i down >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Activating monitor interface"
    #ifconfig $MONITOR up
    ip link set $MONITOR up
    #ifconfig $MONITOR >/dev/null 2>&1
    #while [ $? -ne 0 ]
    ip link show $MONITOR | grep -i down >/dev/null 2>&1
    while [ $? -eq 0 ]
    do
        #ifconfig $MONITOR >/dev/null 2>&1
        ip link show $MONITOR | grep -i down >/dev/null 2>&1
    done
fi

iw dev $IFACE info >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Deleting managed interface"
    iw dev $IFACE del
fi

# set channel and frequency
channel=$(./channel.sh)
if [ "$channel" -ne $CHANNEL ]; then
    echo "Setting channel and frequency"
    iw dev $MONITOR set channel $CHANNEL $MODE
    channel=$(./channel.sh)
    while [ "$channel" -ne $CHANNEL ]
    do
        sleep 1
        iw dev $MONITOR set channel $CHANNEL $MODE
        channel=$(./channel.sh)
    done
fi
echo "Setup done"

