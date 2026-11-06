{ pkgs, ... }:
{
    programs.hyprland.enable = true;
    # uwsm properly starts/stops graphical-session.target (and unsets the
    # env vars it imported) when Hyprland exits. Without it, nothing ever
    # stops the target on logout, so stale WAYLAND_DISPLAY/XDG_CURRENT_DESKTOP/
    # HYPRLAND_INSTANCE_SIGNATURE values stick around in the systemd --user
    # environment and break the next GNOME login (it bounces back to gdm).
    programs.hyprland.withUWSM = true;
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;

    i18n.inputMethod = {
        enable = true;
        type = "ibus";
    };

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
        satty
        swaybg
    ];

}
