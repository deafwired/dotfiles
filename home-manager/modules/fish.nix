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

            # proxy
            if test -e /run/hotspot-proxy.env
                for line in (cat /run/hotspot-proxy.env)
                    set -l parts (string split -m1 '=' -- $line)
                    if test (count $parts) -eq 2
                        set -gx $parts[1] $parts[2]
                    end
                end
            else
                set -e http_proxy
                set -e https_proxy
                set -e HTTP_PROXY
                set -e HTTPS_PROXY
                set -e no_proxy
                set -e NO_PROXY
            end
        '';

        shellAliases = {
            rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles";
            update = "sudo nix flake update --flake ~/dotfiles";
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
