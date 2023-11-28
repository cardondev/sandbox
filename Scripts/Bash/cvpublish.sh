#!/bin/bash

#  +----------------------------------------------------+
#  |                     Script Info                    |
#  +----------------------------------------------------+
#  | Script Name    : cvpublish.sh                      |
#  | Author         : Cardondev                         |
#  | Date Created   : 27 November 2023                  |
#  | Last Modified  : Cardondev                         |
#  | Date Modified  : 11/27/23                          |
#  | Version        : v1.0                              |
#  | Description    : This Script automates monthly-    |
#  | publishing of Satellite content views.             |  
#  +----------------------------------------------------+
#  |                Revision History                    |
#  +----------------------------------------------------+
#  | Date      Author's Name  Version  Changes          |
#  | 11/27/23  Cardondev      v1.0     Created          |
#  +----------------------------------------------------+

# Log File
LOG_OUTPUT="/tmp/cvpub.out"

# Logic to obtain the current month
get_current_month() {
    echo $(date +%B)
}
# Variables
publish_content_view() {
    local month=$(get_current_month)
    local description="${month} Patching"
    local name=$1
    local organization=$2
    local start_time=$(date +%s)

# Logic to output in console and execute hammer command
    echo "Publishing content view: $name description: $description" | tee -a "$LOG_OUTPUT"
    hammer content-view publish --description "$description" --name "$name" --organization "$organization" | tee -a "$LOG_OUTPUT"

    local end_time=$(date +%s)
    local time_taken=$((end_time - start_time))
    echo "Time taken for $name: $time_taken seconds" | tee -a "$LOG_OUTPUT"

    # Sleep for 10 seconds before the next task
    sleep 10
}

# Publish content views with the current month in the description
publish_content_view "contentview1" "myorg" # Replace <contentview> placeholder with the name of your content view
publish_content_view "contentview2" "myorg" # Replace <myorg> placeholder with the name of your organization
publish_content_view "contentview3" "myorg"
