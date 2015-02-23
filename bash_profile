export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/opt/oracle/instantclient_11_2
export PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/opt/oracle/instantclient_11_2:$PATH
export CLASSPATH=$CLASSPATH:$ORACLE_HOME
export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH

export LESSOPEN="| source-highlight --out-format esc --style-file ~/.source-highlight/madders.style --failsafe -i \"%s\""
export LESS=-R

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

