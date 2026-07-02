{ ... }:
{
    imports = [ ../../stylix/common.nix ];

    stylix.targets = {
        # keep the hand-tuned CSS for these; colors are injected from
        # config.lib.stylix.colors in their own modules instead
        waybar.enable = false;
        wofi.enable = false;

        # stylix uses a blue (base0D) active border and hyprpaper; we keep the
        # green (base0B) border and swaybg by injecting colors in hyprland.nix
        hyprland.enable = false;

        firefox.profileNames = [ "default" ];
    };
}
