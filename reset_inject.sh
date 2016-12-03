#!/usr/bin/sudo /bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: ./reset_inject.sh <Wiphy> <monitor_iface> <interface>"
    exit
fi

PHY=$1
MONITOR=$2
IFACE=$3

ip link show $MONITOR >/dev/null 2>&1
if [ $? -eq 0 ]; then
    ip link show $MONITOR | grep -i down >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Deactivating monitor interface"
        ip link set $MONITOR down
    fi

    iw dev $MONITOR info >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Deleting monitor interface"
        iw dev $MONITOR del
    fi
fi

ip link show $IFACE >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Creating managed interface"
    iw phy $PHY interface add $IFACE type managed
fi

echo "Reset done"

