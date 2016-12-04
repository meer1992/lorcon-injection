IFACE=$1

freq=$(iw dev $IFACE info | sed -n -r 's/.*channel ([0-9]{1,3}).*/\1/p')

# if `iw dev $IFACE info` returns channel number
# (newer kernel version)
if [ -n "$freq" ]; then
    echo $freq
    exit
fi

# (older kernel version)
freq=$(iwconfig $IFACE | sed -n -r 's/.*(2\.[0-9]{3}).*/\1/p')
if [ -z "$freq" ];
then
    echo -1
    exit
fi
freqMHz=$(echo "1000*$freq" | bc)

band24=$(echo "$freqMHz<2500" | bc)
band50=$(echo "$freqMHz>5000" | bc)
if [ "$band24" -eq 1 ]; then
    echo "($freqMHz - 2407)/5" | bc
fi
if [ "$band50" -eq 1 ]; then
    echo "34 + ($freqMHz - 5170)/5" | bc
fi

