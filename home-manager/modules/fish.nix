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
            rebuild = "sudo nix flake update --flake ~/dotfiles && sudo nixos-rebuild switch --flake ~/dotfiles";
            cd = "z";
            dim = "brightnessctl set 1";
            nf = "fastfetch";
            nix-shell = "nix-shell --run fish";
            ls = "ls --color=auto";
            lg = "lazygit";
            vi = "nvim";
        };

        plugins = [
              { name = "grc"; src = pkgs.fishPlugins.grc.src; }
        ];

        functions = {
            hrebuild = {
                body = ''
                    switch (hostname)
                        case artemis
                            home-manager switch --flake ~/dotfiles#artemis
                        case laptop
                            home-manager switch --flake ~/dotfiles#laptop
                        case server
                            home-manager switch --flake ~/dotfiles#server
                        case '*'
                            home-manager switch --flake ~/dotfiles#matt
                    end
                '';
            };

            starship_transient_prompt_func = {
                body = "starship module character && echo";
            };
        };
    };
}
