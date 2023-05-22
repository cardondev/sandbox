#!/bin/bash

# Define the output file
output_file="splunk_status.csv"

# Start by creating the header in the CSV file
echo "Server,Status" > $output_file

# Loop through each server in the servers file
while read -r server; do
  # SSH into the server, restart Splunk and get the status
  status=$(ssh user@"$server" 'sudo /opt/splunk/bin/splunk restart; sleep 10; sudo /opt/splunk/bin/splunk status')

  # Write the server and status to the CSV file
  echo "$server,$status" >> $output_file

done < /tmp/servers.txt
