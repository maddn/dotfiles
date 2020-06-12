if set -l index (contains -i '/Applications/VMware Fusion.app/Contents/Public' $PATH)
  set --erase --global PATH[$index]
end

set -g fish_user_paths "/usr/local/opt/python/libexec/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
set -g fish_user_paths /Applications/MacVim.app/Contents/bin ~/nso/tailf-doc-tools/bin $fish_user_paths

bass source ~/nso/git/tailf/env.sh
source ~/.iterm2_shell_integration.fish
