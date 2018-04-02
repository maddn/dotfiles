function fish_prompt
    and set retc blue
    or set retc red

    echo
    iterm2_prompt_mark

    set_color red
    echo -n ' ┌─['
    fish_default_mode_prompt

    set_color red
    echo -n ']──['

    set_color $retc
    echo -n $USER
    echo -n @
    echo -n (prompt_hostname)

    set_color red
    echo -n ']──['

    set_color yellow
    echo -n (pwd|sed "s=$HOME=~=")

    set_color red
    echo ']'
    echo -n ' └───> '

    set_color normal
end
