function dev() {
  BIND_IP=127.0.0.2
  BIND_HOME=${HOME//#\/Users/\/home}
  ifconfig lo0 | grep -q "$BIND_IP" || sudo -n /sbin/ifconfig lo0 alias "$BIND_IP"
  touch ~/.fish_history
  docker run -v ~/git:${BIND_HOME}/git \
             -v ~/nso:${BIND_HOME}/nso:delegated \
             -v ~/.ssh:${BIND_HOME}/.ssh \
             -v ~/Downloads:${BIND_HOME}/Downloads \
             -v ~/.fish:${BIND_HOME}/.local/share/fish \
             -v /var/run/docker.sock:/run/docker.sock \
             -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
             -v nso-run:${BIND_HOME}/nso-run \
             -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
             -p "${BIND_IP}:8080:8080" \
             -p "${BIND_IP}:8888:8888" \
             -p "${BIND_IP}:3000:3000" \
             -p "${BIND_IP}:4000:4000" \
             -p "${BIND_IP}:4001:4001" \
             -p "${BIND_IP}:8000:8000" \
             -p "${BIND_IP}:8010:8010" \
             -p "${BIND_IP}:18080:18080" \
             -p "${BIND_IP}:28080:28080" \
             -p "${BIND_IP}:13389:13389" \
             -p "${BIND_IP}:30603:30603" \
             --hostname maddn-dev \
             --cap-add=NET_ADMIN \
             --detach-keys="ctrl-p,ctrl-x" \
             --rm --init -it maddn-dev
}
