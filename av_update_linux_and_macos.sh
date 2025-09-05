#!/bin/bash
# GreenShell Security Marker Script - Max Detail
# Safe, traceable marker for testing

MARKER_FILE="$HOME/greenshell_marker.txt"

# Basic system info
USER_NAME=$(whoami)
HOST_NAME=$(hostname)
OS_INFO=$(uname -a)
DATE_TIME=$(date "+%Y-%m-%d %H:%M:%S")
IP_ADDR=$(hostname -I | awk '{print $1}')
UPTIME_INFO=$(uptime -p)

# Top resource usage
TOP_PROCESSES=$(ps -eo comm,%cpu,%mem --sort=-%cpu | head -5 | awk '{print $1":"$2"% CPU,"$3"% MEM"}' | tr '\n' ',')

# Disk usage (root filesystem)
DISK_USAGE=$(df -h / | awk 'NR==2 {print $3 " used / " $2 " total (" $5 " used)"}')

# Network interfaces summary (safe)
NET_IFACES=$(ip -o -4 addr show | awk '{print $2 ":" $4}' | tr '\n' ',')

# Logged in users
LOGGED_USERS=$(who | awk '{ print $1 }' | tr '\n' ',')

# Write info to file
cat <<EOF > "$MARKER_FILE"
[GreenShell Marker - Detailed]
User: $USER_NAME
Host: $HOST_NAME
OS: $OS_INFO
Executed: $DATE_TIME
IP: $IP_ADDR
Uptime: $UPTIME_INFO
DiskUsage: $DISK_USAGE
TopProcesses: $TOP_PROCESSES
NetworkInterfaces: $NET_IFACES
LoggedUsers: $LOGGED_USERS
EOF

echo "Detailed GreenShell marker created at $MARKER_FILE"
