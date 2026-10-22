function dev-build() (
  cd "$HOME/git/dotfiles" || return
  BUILDX_GIT_INFO=false docker compose build "$@"
)

function dev-start() (
  cd "$HOME/git/dotfiles" || return
  source ./.env
  ifconfig lo0 | grep -q "$BIND_IP" || sudo -n /sbin/ifconfig lo0 alias "$BIND_IP"
  touch ~/.fish_history
  docker compose up --wait --wait-timeout 30 --no-build --no-recreate
)

function dev-attach() (
  docker exec -it --detach-keys="ctrl-p,ctrl-x" maddn-dev tmux attach-session -d -t dev-docker
)

function dev-stop() (
  cd "$HOME/git/dotfiles" || return
  docker compose down
)

function dev() (
  dev-start && dev-attach
)
