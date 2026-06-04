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

    home.packages = with pkgs; [ neovim ];
}
