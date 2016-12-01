#!/usr/bin/sudo /bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: ./setup_inject.sh <channel> {HT20|HT40-|HT40+}"
    exit
fi

lsmod | grep iwl 2>/dev/null 1>/dev/null
if [ $? -eq 0 ]; then
    echo "Reloading iwl driver"
    modprobe -r iwldvm iwlwifi mac80211 cfg80211
    modprobe iwlwifi debug=0x40000
    ifconfig wlan0 2>/dev/null 1>/dev/null
    while [ $? -ne 0 ]
    do
        ifconfig wlan0 2>/dev/null 1>/dev/null
    done
fi

# create mon0 if not exist
ip link show mon0 2>/dev/null 1>/dev/null
if [ $? -ne 0 ]; then
    echo "Creating monitor interface"
    iw dev wlan0 interface add mon0 type monitor
    ip link show mon0 2>/dev/null 1>/dev/null
    while [ $? -ne 0 ]
    do
        ip link show mon0 2>/dev/null 1>/dev/null
    done
fi

# activate mon0 if not
ifconfig mon0 2>/dev/null 1>/dev/null
if [ $? -ne 0 ]; then
    echo "Activating monitor interface"
    ifconfig mon0 up
    ifconfig mon0 2>/dev/null 1>/dev/null
    while [ $? -ne 0 ]
    do
        ifconfig mon0 2>/dev/null 1>/dev/null
    done
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

