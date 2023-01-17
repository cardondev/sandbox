#!/bin/bash

var1=$(ls /dev/sd*)

var2="badblocks_output"

echo "badblocks_output" > $var2
echo "----------------------------" >> $var2

for a in $var1; do

    b=$(badblocks -s -v -n $a 2>&1)

    # Check if the result contains any bad blocks
    if [[ $b == *"bad blocks"* ]]; then
        echo "Hard Drive $a contains bad blocks:" >> $var2
        echo "$b" >> $var2
    fi
done

cat $var2