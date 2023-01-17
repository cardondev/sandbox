#!/bin/bash

VAR1=86400 

SRC="/maintenance/servers"

while IFS='' read -r SRV || [[ -n "$SRV" ]]; do
    VAR2=$(ssh -t admin@$SERVER 'uptime -s')
    VAR3=$(date +%s)
    VAR4=$(($VAR3 - $VAR2))

    if [ $VAR4 -gt $VAR1 ]; then
        ssh -t admin@$SRV 'sudo reboot'
    fi
done < "$SRC"