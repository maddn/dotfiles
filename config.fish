fish_config theme choose maddn
set --global fish_key_bindings fish_vi_key_bindings
set --global --export LS_COLORS (dircolors -b ~/.dircolors | string split "'")[2]

alias ncs 'ncs --nolog'
alias cli 'ncs_cli -u admin -C'

# Temporary workaround for https://github.com/openai/codex/issues/44329.
function codex
    set -lx PATH $HOME/.local/lib/node_modules/@openai/codex/node_modules/@openai/codex-linux-arm64/vendor/aarch64-unknown-linux-musl/codex-resources $PATH
    command codex $argv
end

[ -d ~/nso-current ] && bass source ~/nso-current/ncsrc
sudo chown mmaddern: /run/host-services/ssh-auth.sock
