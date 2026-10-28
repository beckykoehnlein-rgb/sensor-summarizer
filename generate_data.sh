#!/usr/bin/env bash

set -e   # stop the script if any command fails


if [ -z "$1" ]; then
    echo "Usage: $0 <number_of_files>"
    exit 1
fi


NUM_FILES=$1
ROWS=20
mkdir -p data


for i in $(seq 1 "$NUM_FILES"); do 
    filename="data/sensor_${i}.csv" 
    touch "$filename"
    echo "timestamp,sensor_id,temperature" > $filename
    if (( i % 2 == 0 )); then
        nums=( $(shuf -i 1-"$ROWS" -n 3) )
    fi

    for j in $(seq 1 "$ROWS"); do 
        timestamp=$(( $(date +%s) + j ))
        temperature=$(( RANDOM % 10 + 70 ))

        if (( i % 2 == 0 )); then
            if [[ " ${nums[*]} " == *" $j "* ]]; then
                temperature=$((RANDOM % 10 + 900 ))
                echo "sensor_${i},${temperature}" >> $filename
                continue
            fi
        fi
        echo "${timestamp},sensor_${i},${temperature}" >> $filename
    done 

done 


echo "Generated $NUM_FILES files in data/"
