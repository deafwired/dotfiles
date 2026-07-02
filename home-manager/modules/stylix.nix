{ ... }:
{
    imports = [ ../../stylix/common.nix ];

    stylix.targets = {
        waybar.enable = false;
        wofi.enable = false;

        hyprland.enable = false;

        firefox.profileNames = [ "default" ];
    };
}
