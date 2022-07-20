#!/bin/bash

main() {
    log_i "Starting udev"
    run_udev
}

run_udev() {
    #echo "HELLO"
    service udev start
    wait $!
}

log_i() {
    log "[INFO] ${@}"
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${@}"
}

main
