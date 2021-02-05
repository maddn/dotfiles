export LESSOPEN="| [ -x ~/.local/bin/pygmentize ] && ~/.local/bin/pygmentize -f ~/.config/pygments/maddn.py -x -g %s"
export LESS=-R

# Less Colors for Man Pages
export LESS_TERMCAP_md=$'\e[0;34m'        # begin bold
export LESS_TERMCAP_mb=$'\e[0;31m'        # begin blinking
export LESS_TERMCAP_me=$'\e[0m'           # end mode
export LESS_TERMCAP_so=$'\e[0;36m'        # begin standout-mode - info box
export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
export LESS_TERMCAP_us=$'\e[0;32m'        # begin underline
export LESS_TERMCAP_ue=$'\e[0m'           # end underline


#PS1='\n \[\e[0;31m\]┌─[\[\e[0;34m\]\u@\h\[\e[0;31m\]]──[\[\e[0;33m\]\w\[\e[0;31m\]]\n \[\e[0;31m\]└───>\[\e[0;37m\] '
#PS2='> '
#PS3='> '
#PS4='+ '

set -o vi

if [ -r ~/.bashrc ]; then
   source ~/.bashrc
fi
