{ config, pkgs, ...}: {
    home = {
        username = "matt";
        homeDirectory = "/home/matt";
        stateVersion = "24.11";
    };
    programs.fish = {
        enable = true;
        shellAliases = {
            rebuild = "sudo nixos-rebuild switch";
        };
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
}
