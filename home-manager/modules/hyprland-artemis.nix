{ pkgs, ... }:
let
    dp5Monitor = "DP-5,1920x1080@164.92,2560x0,1,transform,1";
in
{
    wayland.windowManager.hyprland.settings.monitor = [
        "DP-6,2560x1440@144,0x0,1"
        dp5Monitor
    ];

    # Deadlock (and possibly other XWayland/Proton games) size their render
    # surface off the XWayland virtual root at creation time, which is the
    # bounding box of *all* outputs. With DP-5 rotated vertical next to DP-6,
    # that box is oversized/misshapen, so the game only draws into the
    # top-left slice of it. Disabling DP-5 until the game window appears,
    # then re-enabling it, makes the surface init at DP-6's real size.
    # Steam launch options: `deadlock-launch %command%`
    home.packages = [
        (pkgs.writeShellScriptBin "deadlock-launch" ''
            #!/usr/bin/env bash
            set -e

            ${pkgs.hyprland}/bin/hyprctl keyword monitor "DP-5,disable"

            (
                for i in $(seq 1 60); do
                    ${pkgs.hyprland}/bin/hyprctl clients | grep -q "class: steam_app_1422450" && break
                    sleep 0.5
                done
                sleep 1
                ${pkgs.hyprland}/bin/hyprctl keyword monitor "${dp5Monitor}"
            ) &

            exec "$@"
        '')
    ];

    xdg.portal.extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
    ];
}
