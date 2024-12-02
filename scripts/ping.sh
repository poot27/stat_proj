#!/bin/bash

# IP address, port to tcping, and log file name
TARGET_IP="10.0.0.138"
PORT="80"
LOG_FILE="log.txt"

# Function to get current date in custom format
get_date() {
    date +"%Y-%m-%d"
}

# Get current date and add to file
current_date=$(get_date)
echo -n "$current_date: " >> "$LOG_FILE"

# Continuous loop
while true; do
    # Get tcping result in milliseconds
    # TCPing: https://github.com/pouriyajamshidi/tcping
    tcping_result=$(tcping -c 1 -t 1 "$TARGET_IP" "$PORT" | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
    
    # Check if tcping was successful and under 50 ms
    if [[ -n "$tcping_result" && $(echo "$tcping_result < 50" | bc -l) -eq 1 ]]; then
        echo -n "pass," >> "$LOG_FILE"
    else
        echo -n "fail," >> "$LOG_FILE"
    fi
    
    # Check if the date has changed, start new line if yes
    new_date=$(get_date)
    if [[ "$new_date" != "$current_date" ]]; then
        echo "" >> "$LOG_FILE"
        echo -n "$new_date: " >> "$LOG_FILE"
        current_date=$new_date
    fi
    
    # Wait for 60 seconds before the next tcping
    sleep 60
done
