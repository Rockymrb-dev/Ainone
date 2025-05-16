#!/bin/bash

# Start transmission-daemon
transmission-daemon -g /etc/transmission-daemon

# Start filebrowser
filebrowser -c /etc/filebrowser/filebrowser.db &

# Start tmate session for remote access
tmate -F &

# Print tmate link (wait a bit for tmate to start)
sleep 5
tmate show-messages | grep "ssh" || echo "Wait for tmate session to start..."

# Prevent container from exiting
tail -f /dev/null
