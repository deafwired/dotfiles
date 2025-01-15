if status is-interactive
    # Commands to run in interactive sessions can go here
end
set fish_greeting
set EDITOR nvim
set VISUAL $EDITOR
# alias explorer ranger
# alias ls exa
# alias cat bat
alias cd z
alias dim "brightnessctl set 1"
alias nf fastfetch
alias ssh "kitten ssh"
alias vi nvim
alias nix-shell "nix-shell --run fish"
alias rebuild "sudo nixos-rebuild switch"
set PRINTER "Brother_HL-3070CW_series"
export PRINTER
starship init fish | source
zoxide init fish | source
# pfetch
function starship_transient_prompt_func
   starship module character && echo
end

enable_transience
