if status is-interactive
    # fastfetch
    echo " ██▓    ▓█████  ▄████▄   ▄▄▄        ██████ ▓█████  █    ██   ██████ 
▓██▒    ▓█   ▀ ▒██▀ ▀█  ▒████▄    ▒██    ▒ ▓█   ▀  ██  ▓██▒▒██    ▒ 
▒██░    ▒███   ▒▓█    ▄ ▒██  ▀█▄  ░ ▓██▄   ▒███   ▓██  ▒██░░ ▓██▄   
▒██░    ▒▓█  ▄ ▒▓▓▄ ▄██▒░██▄▄▄▄██   ▒   ██▒▒▓█  ▄ ▓▓█  ░██░  ▒   ██▒
░██████▒░▒████▒▒ ▓███▀ ░ ▓█   ▓██▒▒██████▒▒░▒████▒▒▒█████▓ ▒██████▒▒
░ ▒░▓  ░░░ ▒░ ░░ ░▒ ▒  ░ ▒▒   ▓▒█░▒ ▒▓▒ ▒ ░░░ ▒░ ░░▒▓▒ ▒ ▒ ▒ ▒▓▒ ▒ ░
░ ░ ▒  ░ ░ ░  ░  ░  ▒     ▒   ▒▒ ░░ ░▒  ░ ░ ░ ░  ░░░▒░ ░ ░ ░ ░▒  ░ ░
  ░ ░      ░   ░          ░   ▒   ░  ░  ░     ░    ░░░ ░ ░ ░  ░  ░  
    ░  ░   ░  ░░ ░            ░  ░      ░     ░  ░   ░           ░  
               ░                                                    "
    set fish_greeting
    starship init fish | source
    set -gx EDITOR hx
    set -gx PATH $HOME/.local/bin $PATH
    cat ~/.cache/wal/sequences
    alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    alias record='gpu-screen-recorder -w portal -f 60 -k h264 -encoder cpu -o ~/Videos/recording_$(date +%Y%m%d_%H%M%S).mp4'
end
