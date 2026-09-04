{ pkgs, ... }:

let
    hotspotSsid = "DIRECT-TF-deafwired";
    proxyUrl = "http://192.168.49.1:8228";
    proxyEnvFile = "/run/hotspot-proxy.env";

    dispatcherScript = pkgs.writeShellScript "hotspot-proxy-dispatcher" ''
        action="$2"
        case "$action" in
            up|down) ;;
            *) exit 0 ;;
        esac

        active_ssid=$(${pkgs.networkmanager}/bin/nmcli -t -f active,ssid dev wifi 2>/dev/null \
            | ${pkgs.gnugrep}/bin/grep '^yes:' | ${pkgs.coreutils}/bin/cut -d: -f2-)

        if [ "$active_ssid" = "${hotspotSsid}" ]; then
            if [ ! -f "${proxyEnvFile}" ]; then
                cat > "${proxyEnvFile}" <<EOF
http_proxy=${proxyUrl}
https_proxy=${proxyUrl}
HTTP_PROXY=${proxyUrl}
HTTPS_PROXY=${proxyUrl}
no_proxy=localhost,127.0.0.1,::1
NO_PROXY=localhost,127.0.0.1,::1
EOF
                ${pkgs.systemd}/bin/systemctl try-restart nix-daemon.service
            fi
        else
            if [ -f "${proxyEnvFile}" ]; then
                rm -f "${proxyEnvFile}"
                ${pkgs.systemd}/bin/systemctl try-restart nix-daemon.service
            fi
        fi
    '';
in
{
    networking.networkmanager.dispatcherScripts = [
        {
            source = dispatcherScript;
            type = "basic";
        }
    ];

    systemd.services.nix-daemon.serviceConfig.EnvironmentFile = "-${proxyEnvFile}";

    security.sudo.extraConfig = ''
        Defaults env_keep += "http_proxy https_proxy HTTP_PROXY HTTPS_PROXY no_proxy NO_PROXY"
    '';
}
