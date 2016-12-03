#!/usr/bin/sudo /bin/bash

PHY=phy0
IFACE=wlp1s0

echo "Deactivating monitor interface"
ip link set mon0 down
echo "Deleting monitor interface"
iw dev mon0 del
echo "Creating managed interface"
iw phy $PHY interface add $IFACE type managed

echo "Reset done"

