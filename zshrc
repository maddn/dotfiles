function dev() {
  BIND_HOME=${HOME//#\/Users/\/home}
  touch ~/.fish_history
  docker run -v ~/git:${BIND_HOME}/git \
             -v ~/nso:${BIND_HOME}/nso:delegated \
             -v ~/.ssh:${BIND_HOME}/.ssh \
             -v ~/Downloads:${BIND_HOME}/Downloads \
             -v ~/.fish_history:${BIND_HOME}/.local/share/fish/fish_history \
             -v /var/run/docker.sock:/run/docker.sock \
             -v tme-demo-node-modules:${BIND_HOME}/nso/git/tme-demo/packages/tme-demo-ui/src/webui/node_modules \
             -p 80:8080 \
             --hostname maddn-dev \
             --rm --init -it maddn-dev
}
