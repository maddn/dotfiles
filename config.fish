alias ncs 'ncs --nolog'
alias cli 'ncs_cli -u admin -C'
[ -d ~/nso-current ] && bass source ~/nso-current/ncsrc
sudo chown mmaddern: /run/host-services/ssh-auth.sock
