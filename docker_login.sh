#!/bin/sh

/usr/sbin/syslog-ng --no-caps > /dev/null 2>&1
/usr/sbin/sshd
make -C ~/git/dotfiles theme || exit
exec tmux -D -f /dev/stdin <<'EOF'
source-file ~/.tmux.conf
new-session -d -s dev-docker
EOF
