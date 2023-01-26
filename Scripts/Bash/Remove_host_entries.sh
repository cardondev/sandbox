#!/bin/bash

# Get server list from /tmp/listfile
server_list=$(cat /tmp/listfile)

# Loop through server list
for server in $server_list; do
    # SSH to server as unixdata and check if the entry exists
    if ! ssh admin@$server "sudo grep -q '192.20.20.21 domain2.com' /etc/hosts"; then
        echo "Entry does not exist in /etc/hosts on $server. Skipping."
        continue
    fi

    # SSH to server as unixdata and execute commands as sudo to remove the entry
    ssh unixdata@$server "sudo sed -i '/192.20.20.21 domain2.com/d' /etc/hosts"
    echo "Successfully removed 192.20.20.21 domain2.com from /etc/hosts on $server"
done