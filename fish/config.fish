if status is-interactive
    # Commands to run in interactive sessions can go here
end
set fish_greeting
set VISUAL $EDITOR
set EDITOR nano
alias explorer ranger
starship init fish | source
pfetch
