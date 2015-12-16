export ORACLE_HOME=/opt/oracle/instantclient_11_2
export PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$ORACLE_HOME:$PATH:/opt/android-sdk-macosx/platform-tools
export CLASSPATH=$CLASSPATH:$ORACLE_HOME
export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
export DYLD_LIBRARY_PATH=$ORACLE_HOME:$DYLD_LIBRARY_PATH
export TNS_ADMIN=$ORACLE_HOME/network/admin
export EDITOR=/usr/local/bin/vim
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_75.jdk/Contents/Home

export LESSOPEN="| source-highlight --out-format esc --style-file ~/.source-highlight/madders.style --failsafe -i \"%s\""
export LESS=-R

alias more='more --no-lessopen'

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\e[0;31m'        # begin blinking
export LESS_TERMCAP_md=$'\e[0;34m'        # begin bold
export LESS_TERMCAP_me=$'\e[0m'           # end mode
export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\e[0;36m'        # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\e[0m'           # end underline
export LESS_TERMCAP_us=$'\e[0;32m'        # begin underline

PS1='\n \[\e[0;31m\]┌─[\[\e[0;34m\]\u@\h\[\e[0;31m\]]──[\[\e[0;33m\]\w\[\e[0;31m\]]\n \[\e[0;31m\]└───>\[\e[0;37m\] '

PS2='> '
PS3='> '
PS4='+ '

alias ls='ls --color=auto'
set -o vi

eval $(dircolors ~/.dir_colors)

. ~/nso/nso-4.0.2/ncsrc

