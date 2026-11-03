#!/bin/sh

sudo -n chown "$(id -un):" /run/host-services/ssh-auth.sock || exit
sudo -n /usr/sbin/syslog-ng --no-caps || exit
sudo -n /usr/sbin/sshd || exit
make -C ~/git/dotfiles theme || exit
exec tmux -D -f /dev/stdin <<'EOF'
source-file ~/.tmux.conf
new-session -d -s dev-docker
EOF
