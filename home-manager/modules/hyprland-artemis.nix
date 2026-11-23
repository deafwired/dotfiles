{ pkgs, inputs, config, ... }:
let
    verticalMonitor = "DP-6,1920x1080@164.92,2560x0,1,transform,1";
    wayvncDir = "${config.home.homeDirectory}/.config/wayvnc";
in
{
    # Remote desktop (phone/laptop) over Tailscale. wayvnc talks to Hyprland
    # directly via wlr-screencopy/virtual-pointer/virtual-keyboard, no portal
    # needed. It binds every interface, but nixos/artemis.nix only lets
    # tailscale0 reach the port, so it's unreachable from the LAN/WAN NICs.
    # Auth is PAM (your real Linux password, typed in the VNC client), so
    # there's no secret in this repo; TLS still needs a cert, which this
    # generates on first run instead of needing a manual openssl step.
    home.file.".config/wayvnc/config".text = ''
        address=0.0.0.0
        enable_auth=true
        enable_pam=true
        private_key_file=${wayvncDir}/tls_key.pem
        certificate_file=${wayvncDir}/tls_cert.pem
    '';

    systemd.user.services.wayvnc = {
        Unit = {
            Description = "wayvnc remote desktop server for the Hyprland session";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
        };
        Service = {
            ExecStartPre = "${pkgs.writeShellScript "wayvnc-gen-tls" ''
                set -e
                if [ ! -f "${wayvncDir}/tls_key.pem" ] || [ ! -f "${wayvncDir}/tls_cert.pem" ]; then
                    ${pkgs.openssl}/bin/openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:secp384r1 -sha384 \
                        -days 3650 -nodes -keyout "${wayvncDir}/tls_key.pem" -out "${wayvncDir}/tls_cert.pem" \
                        -subj /CN=artemis \
                        -addext subjectAltName=DNS:artemis,IP:127.0.0.1
                fi
            ''}";
            ExecStart = "${pkgs.wayvnc}/bin/wayvnc --config=${wayvncDir}/config";
            Restart = "on-failure";
            RestartSec = 2;
        };
        Install.WantedBy = [ "graphical-session.target" ];
    };

    wayland.windowManager.hyprland.settings.monitor = [
        "DP-5,2560x1440@240,0x0,1"
        verticalMonitor
        # Anything else (HDMI TV/projector): preferred mode, placed to the
        # right of the existing layout instead of overlapping it.
        ",preferred,auto-right,1"
    ];

    wayland.windowManager.hyprland.settings.exec-once = [
        "artemis-startup-apps"
    ];

    # Always open Vesktop/Spotify on workspace 2 (DP-6), silently, so they
    # land there directly instead of needing a script to move them after
    # the fact. Electron apps often carry fixed-size hints that make
    # Hyprland auto-float them, so also force them tiled.
    wayland.windowManager.hyprland.settings.windowrule = [
        "float off, match:class ^(vesktop)$"
        "float off, match:class ^(Spotify)$"
        "workspace 2 silent, match:class ^(vesktop)$"
        "workspace 2 silent, match:class ^(Spotify)$"
    ];

    # Odd workspaces on the primary horizontal monitor (DP-5), even on the
    # vertical one (DP-6).
    wayland.windowManager.hyprland.settings.workspace = [
        "1, monitor:DP-5"
        "2, monitor:DP-6"
        "3, monitor:DP-5"
        "4, monitor:DP-6"
        "5, monitor:DP-5"
        "6, monitor:DP-6"
        "7, monitor:DP-5"
        "8, monitor:DP-6"
        "9, monitor:DP-5"
        "10, monitor:DP-6"
    ];

    # Deadlock (and possibly other XWayland/Proton games) size their render
    # surface off the XWayland virtual root at creation time, which is the
    # bounding box of *all* outputs. With DP-6 rotated vertical next to DP-5,
    # that box is oversized/misshapen, so the game only draws into the
    # top-left slice of it. Disabling DP-6 until the game window appears,
    # then re-enabling it, makes the surface init at DP-5's real size.
    # Steam launch options: `deadlock-launch %command%`
    home.packages = [
        inputs.grimoire.packages.${pkgs.system}.default

        (pkgs.writeShellScriptBin "artemis-startup-apps" ''
            #!/usr/bin/env bash
            set -e

            ${pkgs.hyprland}/bin/hyprctl dispatch exec vesktop
            ${pkgs.hyprland}/bin/hyprctl dispatch exec spotify

            for i in $(seq 1 60); do
                ${pkgs.hyprland}/bin/hyprctl clients | grep -q "class: vesktop" && break
                sleep 0.5
            done

            # Spotify's window can replace itself (splash -> main) right
            # after launch, so wait a moment before resizing. Target Vesktop
            # by class rather than focusing it first, so this never steals
            # focus from whatever workspace is actually active.
            sleep 1
            ${pkgs.hyprland}/bin/hyprctl dispatch resizewindowpixel "exact 1080 1000,class:^(vesktop)$"
        '')

        (pkgs.writeShellScriptBin "deadlock-launch" ''
            #!/usr/bin/env bash
            set -e

            ${pkgs.hyprland}/bin/hyprctl keyword monitor "DP-6,disable" || true

            (
                for i in $(seq 1 60); do
                    ${pkgs.hyprland}/bin/hyprctl clients | grep -q "class: steam_app_1422450" && break
                    sleep 0.5
                done
                sleep 1
                ${pkgs.hyprland}/bin/hyprctl keyword monitor "${verticalMonitor}"

                # Floating windows that were reflowed onto DP-5 while DP-6 was
                # disabled keep their old pixel coordinates once DP-6 comes
                # back, which can leave them positioned off of every monitor.
                # Re-center KeePassXC (workspace 10, DP-6) and hand focus back
                # to the game.
                sleep 0.5
                if ${pkgs.hyprland}/bin/hyprctl clients | grep -q "class: org.keepassxc.KeePassXC"; then
                    ${pkgs.hyprland}/bin/hyprctl dispatch focuswindow "class:^(org.keepassxc.KeePassXC)$"
                    ${pkgs.hyprland}/bin/hyprctl dispatch centerwindow
                    ${pkgs.hyprland}/bin/hyprctl dispatch focuswindow "class:^(steam_app_1422450)$"
                fi
            ) &

            exec "$@"
        '')
    ];
}
