{ pkgs, ... }:
{
    programs.niri.enable = true;

    # Same KDE Connect remote-input fix as hyprland.nix, routed for niri sessions.
    xdg.portal.extraPortals = [ (pkgs.callPackage ../packages/hypr-kdeconnect-fix.nix { }) ];
    xdg.portal.config.niri."org.freedesktop.impl.portal.RemoteDesktop" = "hypr-kdeconnect";

    environment.systemPackages = with pkgs; [
        wl-clipboard
        brightnessctl
        playerctl
        dunst
        waybar
        wofi
        hyprpicker
        grimblast
        swaybg
    ];

}
