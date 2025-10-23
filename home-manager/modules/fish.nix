{ config, pkgs, ...}: {
    programs.fish = {
        enable = true;
        
        interactiveShellInit = ''
            set fish_greeting # Disable greeting
            set EDITOR nvim
            set VISUAL $EDITOR
            starship init fish | source
            zoxide init fish | source
            enable_transience
            set fish_user_paths $HOME/.local/bin $fish_user_paths
        '';

        shellAliases = {
            rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles";
            hrebuild = "home-manager switch --flake ~/dotfiles";
            cd = "z";
            dim = "brightnessctl set 1";
            nf = "fastfetch";
            nix-shell = "nix-shell --run fish";
            lg = "lazygit";
        };

        plugins = [
              { name = "grc"; src = pkgs.fishPlugins.grc.src; }
        ];

        functions = {
            starship_transient_prompt_func = {
                body = "starship module character && echo";
            };
        };
    };
}
