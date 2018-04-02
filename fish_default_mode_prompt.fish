function fish_default_mode_prompt --description 'Display the default mode for the prompt'
  # Do nothing if not in vi mode
  if test "$fish_key_bindings" = "fish_vi_key_bindings"
    or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
    switch $fish_bind_mode
      case default
        set_color red
        echo -n 'N'
      case insert
        set_color green
        echo -n 'I'
      case replace_one
        set_color green
        echo -n 'R'
      case visual
        set_color magenta
        echo -n 'V'
    end
    set_color normal
  end
end
