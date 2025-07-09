function dev() {
  BIND_HOME=${HOME//#\/Users/\/home}
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
             -p 8080:8080 \
             -p 8888:8888 \
             -p 3000:3000 \
             -p 4000:4000 \
             -p 8000:8000 \
             -p 8010:8010 \
             -p 18080:18080 \
             -p 28080:28080 \
             -p 13389:13389 \
             -p 30603:30603 \
             --hostname maddn-dev \
             --cap-add=NET_ADMIN \
             --detach-keys="ctrl-p,ctrl-x" \
             --rm --init -it maddn-dev
}
