{ config, pkgs, ...}: {

    imports = [
        ./modules/bundle.nix
    ];

    home = {
        username = "matt";
        homeDirectory = "/home/matt";
        stateVersion = "24.11";
    };
    
    programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        plugins = with pkgs.vimPlugins; [
            nvim-lspconfig
            nvim-treesitter
        ];
    };
    
    programs.home-manager.enable = true;
}
