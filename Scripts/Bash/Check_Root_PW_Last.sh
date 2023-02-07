#!/bin/bash

# Parse the server list from /tmp
server_list=$(cat /tmp/serverlist)

# Loop through the list of servers
for server in $server_list; do
  # SSH as the user "unixdata" and change the root password
  ssh unixdata@$server "sudo mount /linux && sudo bash -c \"echo 'root:\$(cat /linux/chgeroot)' | chpasswd\""
done
