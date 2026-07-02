{ device, lib, ... }:
{
    imports =
        [
            ./fish.nix
            ./firefox.nix
            ./hyprland.nix
            ./niri.nix
            ./waybar.nix
            ./dunst.nix
            ./starship.nix
            ./wofi.nix
            ./lazygit.nix
            # ./kitty.nix
            ./stylix.nix
        ] ++ lib.optionals (device == "artemis") [ ./hyprland-artemis.nix ] ++ lib.optionals (device != "artemis") [ ./hyprland-default.nix ];
}
