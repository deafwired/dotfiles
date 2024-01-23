if status is-interactive
    # Commands to run in interactive sessions can go here
end
set fish_greeting
set VISUAL $EDITOR
set EDITOR nano
alias explorer ranger
alias ls exa
alias cat bat
alias dim "brightnessctl set 1"
starship init fish | source
zoxide init fish | source
pfetch
