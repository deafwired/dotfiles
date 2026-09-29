{ pkgs, ... }:
{
    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;

    # Makes KDE Connect remote input (mouse/keyboard from phone) work under
    # Hyprland: xdg-desktop-portal-hyprland doesn't implement RemoteDesktop,
    # so this fills that one interface. See ../packages/hypr-kdeconnect-fix.nix
    xdg.portal.extraPortals = [ (pkgs.callPackage ../packages/hypr-kdeconnect-fix.nix { }) ];
    xdg.portal.config.hyprland."org.freedesktop.impl.portal.RemoteDesktop" = "hypr-kdeconnect";

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
