#!/usr/bin/env bash
set -euxo pipefail

nohup fcgiwrap -s unix:/run/fcgiwrap.socket &
while [ ! -e /run/fcgiwrap.socket ]; do
    sleep 1
done
chmod 766 /run/fcgiwrap.socket

exec nginx -g "daemon off;"
