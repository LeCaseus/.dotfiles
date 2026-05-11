if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
    set fish_greeting
    starship init fish | source
    export EDITOR=hx
    alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
end
