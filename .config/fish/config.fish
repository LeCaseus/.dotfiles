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
    export PATH="$HOME/.local/bin:$PATH"
    alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/lecaseus/.lmstudio/bin
# End of LM Studio CLI section
