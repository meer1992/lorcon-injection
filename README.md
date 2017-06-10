You need LORCON version 1 to compile this executable.

- install `libpcap-dev`
- download LORCONv1 from http://802.11ninja.net/svn/lorcon/branch/lorcon-old/, or the mirror https://github.com/gsongsong/lorcon-old.git
- compile and `[sudo] make install LORCON`
- `make install` here

How to use:

    ./setup_inject.sh 64 HT20
    echo 0x4101 | sudo tee `find /sys -name monitor_tx_rate`
    sudo ./inject 1 100 1

Please check the source code for `random_packets.c` to understand the meaning of
these parameters and the other parameters that are available.
