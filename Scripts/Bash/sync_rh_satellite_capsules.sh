#!/bin/bash

# Set strict mode
set -euo pipefail

# Configuration variables
CAPSULE_IDS=(2 3 4 5 6 7)

# Function to sync a single capsule
sync_capsule() {
    local capsule_id="$1"
    echo "Starting sync for Capsule ID: $capsule_id"
    hammer capsule content synchronize --id "$capsule_id"
    echo "Sync completed for Capsule ID: $capsule_id"
}

# Main script execution
echo "Starting Satellite Capsule sync process for all capsules simultaneously"

# Start sync processes for all capsules in parallel
for capsule_id in "${CAPSULE_IDS[@]}"; do
    sync_capsule "$capsule_id" &
done

# Wait for all background jobs to complete
wait

echo "All Capsule sync processes have completed"
