#!/bin/bash

# This is a ping sweeper script for /24 networks

# Use:
# ./pingsweep.sh <network_portion_ip>

# Remember to give execution privileges to the file: chmod +x ./pingsweep


# Input validation
if [ "$1" == "" ]; then
    echo "You must enter the network portion of the IP address"
    echo "Syntax: ./pingsweep.sh xxx.xxx.xxx"
else 
    # variables 
    results_temp=$(mktemp)
    mask="$1"

    # loop
    echo -e "\n[*] Scanning the network $1.0/24...\n"
    for ((ip = 1; ip <= 254; ip++)); do
        ping $mask.$ip -c 1 >> $results_temp &
        sleep 0.02
    done

    # filters
    cat "$results_temp" | grep '64 bytes' | cut -d' ' -f4 | tr -d ':' | sort -t '.' -k 4,4n

    # Counting the results
    count=$(cat "$results_temp" | grep '64 bytes' | wc -l)
    echo -e "\n[*] Hosts found: $count"

    # clean the temp file
    rm "$results_temp"
fi