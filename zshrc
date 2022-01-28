function dev() {
  BIND_HOME=${HOME//#\/Users/\/home}
  touch ~/.fish_history
  docker run -v ~/git:${BIND_HOME}/git \
             -v ~/nso:${BIND_HOME}/nso:delegated \
             -v ~/.ssh:${BIND_HOME}/.ssh \
             -v ~/Downloads:${BIND_HOME}/Downloads \
             -v ~/.fish_history:${BIND_HOME}/.local/share/fish/fish_history \
             -v /var/run/docker.sock:/run/docker.sock \
             -v nso-run:${BIND_HOME}/nso-run \
             -p 8080:8080 \
             -p 3000:3000 \
             -p 13389:13389 \
             --hostname maddn-dev \
             --cap-add=NET_ADMIN \
             --rm --init -it maddn-dev
}
