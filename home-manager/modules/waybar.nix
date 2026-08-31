{ config, pkgs, lib, device, ...}:
let
    isArtemis = device == "artemis";

    dndModule = {
        return-type = "json";
        interval = "once";
        signal = 8;
        exec = ''
            if [ "$(dunstctl is-paused)" = "true" ]; then
                printf '{"text": "󰂛", "tooltip": "Notifications paused", "class": "paused"}'
            else
                printf '{"text": "󰂚", "tooltip": "Notifications enabled", "class": "active"}'
            fi
        '';
        on-click = "dunstctl set-paused toggle; pkill -RTMIN+8 waybar";
    };
in
{
    programs.waybar = {
        enable = true;
        settings = {
            mainBar = {
                layer = "top";

                position = "top";

                modules-left = [ "hyprland/workspaces" "tray" "custom/dnd" ];

                modules-center = [ "hyprland/window" ];

                modules-right = [ "network" "pulseaudio" "backlight" "custom/wttrbar" "battery" "clock" ];
                
                "battery" = {
                    states = {
                        warning = 30;
                        critical = 15;
                    };
                    format = "{capacity}% {icon}";
                    format-full = "{capacity}% {icon}";
                    format-charging = " {capacity}% {icon}";
                    format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" ];
                };

                "network" = {
                    format-wifi = "{essid} ({signalStrength}%) ";
                    format-ethernet = "{ipaddr}/{cidr} 󰈀";
                    tooltip-format = "{ifname} via {gwaddr} 󰊙";
                    format-linked = "{ifname} (No IP) 󰊙";
                    format-disconnected = "Disconnected ⚠";
                    format-alt = "{ifname}:{ipaddr}/{cidr}";
                };

                "pulseaudio" = {
                    format = "{volume}% {icon} {format_source}";
                    format-bluetooth = "{volume}% {icon} {format_source}";
                    format-bluetooth-muted = "󰝟 {icon} {format_source}";
                    format-muted = "󰝟 {format_source}";
                    format-source = "{volume}% ";
                    format-source-muted = "";
                    format-icons = {
                        headphone = "";
                        hands-free = "󰥰";
                        headset = "";
                        phone = "";
                        portable = "";
                        car = "";
                        default = ["" "" ""];
                    };
                    on-click = "pavucontrol";
                };
                "clock" = {
                    format = " {:%I:%M %p}";
                    format-alt = " {:%m/%d/%y}";
                    tooltip = false;
                };

                "hyprland/workspaces" = {
                    format = "{name}";
                    # format = "{icon}";
                    tooltip = false;
                    all-outputs = true;
                    # format-icons = {
                    #      active = "";
                    #      default = "";
                    # };
                };

                "temperature" = {
                    critical-threshold = 32;
                    format = "{temperatureF}°F {icon}";
                    format-icons = ["" "" ""];
                };

                "backlight" = {
                    device = "intel_backlight";
                    format = "{percent}% {icon}";
                    format-icons = [""];
                };

                "tray" = {
                    spacing = 10;
                };

                "custom/dnd" = dndModule;

                "custom/wttrbar" = {
                    format = "{}°F";
                    tooltip = true;
                    interval = 3600;
                    exec = "wttrbar --fahrenheit --ampm --date-format %m/%d/%Y";
                    return-type = "json";
                };
            } // lib.optionalAttrs isArtemis {
                # Pin the full bar to the primary horizontal monitor; DP-5 is
                # too narrow and gets verticalBar instead.
                output = [ "DP-6" ];
            };
        } // lib.optionalAttrs isArtemis {
            # Compact bar for artemis's vertical monitor (DP-5), which is too
            # narrow to fit mainBar's modules.
            verticalBar = {
                layer = "top";
                position = "top";
                name = "vertical";

                output = [ "DP-5" ];

                modules-left = [ "hyprland/workspaces" "tray" "custom/dnd" ];
                modules-center = [ ];
                modules-right = [ "network" "pulseaudio" "battery" "clock" ];

                "hyprland/workspaces" = {
                    format = "{name}";
                    tooltip = false;
                    all-outputs = false;
                };

                "tray" = {
                    spacing = 8;
                };

                "custom/dnd" = dndModule;

                "network" = {
                    format-wifi = "{signalStrength} ";
                    format-ethernet = "󰈀";
                    format-disconnected = "󰤭";
                    tooltip-format = "{ifname} via {gwaddr} 󰊙";
                };

                "pulseaudio" = {
                    format = "{volume}% {icon}";
                    format-muted = "󰝟";
                    format-icons = {
                        headphone = "";
                        headset = "";
                        default = ["" "" ""];
                    };
                    on-click = "pavucontrol";
                };

                "battery" = {
                    states = {
                        warning = 30;
                        critical = 15;
                    };
                    format = "{capacity}% {icon}";
                    format-charging = " {capacity}%";
                    format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" ];
                };

                "clock" = {
                    format = "{:%I:%M %p}";
                    format-alt = "{:%m/%d}";
                    tooltip = false;
                };
            };
        };
        style = ''
            @define-color base00 ${config.lib.stylix.colors.withHashtag.base00};
            @define-color base05 ${config.lib.stylix.colors.withHashtag.base05};
            @define-color base08 ${config.lib.stylix.colors.withHashtag.base08};
            @define-color base0B ${config.lib.stylix.colors.withHashtag.base0B};
            * {
                font-family: "${config.stylix.fonts.monospace.name}";
                font-size: ${toString config.stylix.fonts.sizes.desktop}px;
            }
        '' + builtins.readFile ./waybar.css;
    };
}
