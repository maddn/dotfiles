#!/bin/sh

syslog-ng --no-caps > /dev/null 2>&1
tmux new-session -s dev-docker
