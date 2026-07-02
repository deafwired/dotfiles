{ config, pkgs, ...}:{
    programs.waybar = {
        enable = true;
        settings = {
            mainBar = {
                layer = "top";

                position = "top";

                modules-left = [ "hyprland/workspaces" "tray" ];

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
                
                "custom/wttrbar" = {
                    format = "{}°F";
                    tooltip = true;
                    interval = 3600;
                    exec = "wttrbar --fahrenheit --ampm --date-format %m/%d/%Y";
                    return-type = "json";
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
