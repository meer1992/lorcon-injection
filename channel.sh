freq=$(iwconfig mon0 | sed -n -r 's/.*(2\.[0-9]{3}).*/\1/p')
freqMHz=$(echo "1000*$freq" | bc)

band24=$(echo "$freqMHz<2500" | bc)
band50=$(echo "$freqMHz>5000" | bc)
if [ "$band24" -eq 1 ]; then
    echo "($freqMHz - 2407)/5" | bc
fi
if [ "$band50" -eq 1 ]; then
    echo "34 + ($freqMHz - 5170)/5" | bc
fi

