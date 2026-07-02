{ pkgs, ... }:
{
    stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
        image = ../wallpapers/background.png;

        fonts = {
            monospace = {
                package = pkgs.pixel-code;
                name = "Pixel Code";
            };
            sizes = {
                terminal = 20;
                desktop = 16;
                popups = 16;
                applications = 12;
            };
        };

        cursor = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Classic";
            size = 24;
        };
    };
}
