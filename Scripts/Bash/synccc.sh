#!/bin/bash

# Set strict mode
set -euo pipefail

# Configuration variables
CAPSULE_IDS=(2 3 4 5 6 7)

# Function to monitor and display progress for a single capsule
monitor_progress() {
    local capsule_id="$1"
    local temp_file="$2"
    
    while [[ -e /proc/$3 ]]; do
        if [[ -f "$temp_file" ]]; then
            tail -n 1 "$temp_file" | sed "s/^/Capsule $capsule_id: /"
        fi
        sleep 1
    done
    
    # Final status
    if wait $3 2>/dev/null; then
        echo "Sync completed successfully for Capsule ID: $capsule_id"
    else
        echo "Error: Sync failed for Capsule ID: $capsule_id"
    fi

    rm -f "$temp_file"
}

# Function to start all sync processes in parallel
sync_all_capsules() {
    local pids=()
    local temp_files=()

    for capsule_id in "${CAPSULE_IDS[@]}"; do
        local temp_file=$(mktemp)
        temp_files+=("$temp_file")
        
        echo "Starting sync for Capsule ID: $capsule_id"
        
        # Run hammer command to sync the capsule and capture output
        hammer capsule content synchronize --id "$capsule_id" > "$temp_file" 2>&1 &
        local pid=$!
        pids+=($pid)
        
        # Start monitoring progress in background
        monitor_progress "$capsule_id" "$temp_file" $pid &
    done

    # Wait for all sync processes to complete
    wait "${pids[@]}"
}

# Main script execution
echo "Starting Satellite Capsule sync process for all capsules simultaneously"

# Start sync processes for all capsules in parallel
sync_all_capsules

echo "All Capsule sync processes have completed"
