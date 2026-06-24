{ config, pkgs, ...}: {

    imports = [
        ./modules/bundle.nix
    ];

    home = {
        username = "matt";
        homeDirectory = "/home/matt";
        stateVersion = "25.11";
    };
    
    programs = {
        home-manager = {
            enable = true;
        };
    };

    # make gnome actually dark mode
    dconf = {
        enable = true;
        settings."org/gnome/decktop/interface".color-scheme = "prefer-dark";
    };

    home.packages = with pkgs; [ neovim ];
}
