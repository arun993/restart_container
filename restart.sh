#!/bin/bash

# Log file
LOGFILE="/var/log/docker_restart.log"

# Function to check and restart stopped/exited containers
check_and_restart_containers() {
    while true; do
        # Find stopped/exited containers
        stopped_containers=$(docker ps -a -f "status=exited" -f "status=created" -q)

        # Restart stopped containers
        if [[ ! -z "$stopped_containers" ]]; then
            echo "$(date) - Restarting stopped/exited containers: $stopped_containers" >> "$LOGFILE"
            for container in $stopped_containers; do
                docker restart $container >> "$LOGFILE" 2>&1
            done
        fi

        # Sleep for 30 seconds before the next check
        sleep 30
    done
}

# Run the function in the background
check_and_restart_containers &

# Output the PID of the background process
echo "Container auto-restart script running in the background with PID: $!"
echo "Logs are being written to $LOGFILE"
