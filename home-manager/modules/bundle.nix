{ device, lib, ... }:
{
    imports = 
        [
            ./fish.nix
            ./hyprland.nix
            ./niri.nix
            ./waybar.nix
            ./dunst.nix
            ./starship.nix
            # ./kitty.nix
        ] ++ lib.optionals (device == "artemis") [ ./hyprland-artemis.nix ] ++ lib.optionals (device != "artemis") [ ./hyprland-default.nix ];
}
