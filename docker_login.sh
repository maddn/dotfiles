#!/bin/sh

/usr/sbin/syslog-ng --no-caps > /dev/null 2>&1
/usr/sbin/sshd
tmux new-session -s dev-docker
