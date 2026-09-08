{ config, pkgs, ... }:
{
    home.file.".config/hypr/rofi.sh".source = ./rofi.sh;

    services.swayosd = {
        enable = true;
        stylePath = pkgs.writeText "swayosd-style.css" ''
            @define-color base00 ${config.lib.stylix.colors.withHashtag.base00};
            @define-color base05 ${config.lib.stylix.colors.withHashtag.base05};
            @define-color base0B ${config.lib.stylix.colors.withHashtag.base0B};

            * {
                font-family: "${config.stylix.fonts.monospace.name}";
            }

            window#osd {
                border-radius: 0;
                border: 5px solid @base0B;
                background: @base00;
            }

            window#osd #container {
                margin: 16px;
            }

            window#osd image,
            window#osd label {
                color: @base05;
            }

            window#osd progressbar:disabled,
            window#osd image:disabled {
                opacity: 0.5;
            }

            window#osd progressbar,
            window#osd segmentedprogress {
                min-height: 6px;
                border-radius: 0;
                background: transparent;
                border: none;
            }

            window#osd trough,
            window#osd segment {
                min-height: inherit;
                border-radius: inherit;
                border: none;
                background: alpha(@base05, 0.3);
            }

            window#osd progress,
            window#osd segment.active {
                min-height: inherit;
                border-radius: inherit;
                border: none;
                background: @base0B;
            }

            window#osd segment {
                margin-left: 8px;
            }

            window#osd segment:first-child {
                margin-left: 0;
            }
        '';
    };

    programs.hyprlock = {
        enable = true;
        settings = {
            general = {
                disable_loading_bar = true;
                grace = 5;
                hide_cursor = true;
            };

            background = [
                {
                    path = "screenshot";
                    blur_passes = 3;
                    blur_size = 8;
                }
            ];

            input-field = [
                {
                    monitor = "";
                    size = "250, 50";
                    position = "0, -80";
                    dots_center = true;
                    fade_on_empty = false;
                    outline_thickness = 3;
                    outer_color = "rgb(${config.lib.stylix.colors.base0B})";
                    inner_color = "rgb(${config.lib.stylix.colors.base00})";
                    font_color = "rgb(${config.lib.stylix.colors.base05})";
                    check_color = "rgb(${config.lib.stylix.colors.base0D})";
                    fail_color = "rgb(${config.lib.stylix.colors.base08})";
                    placeholder_text = ''<span foreground="##${config.lib.stylix.colors.base04}">Password...</span>'';
                }
            ];

            label = [
                {
                    monitor = "";
                    text = "$TIME";
                    color = "rgb(${config.lib.stylix.colors.base05})";
                    font_size = 90;
                    position = "0, 80";
                    halign = "center";
                    valign = "center";
                }
                {
                    monitor = "";
                    text = "$USER";
                    color = "rgb(${config.lib.stylix.colors.base04})";
                    font_size = 16;
                    position = "0, -160";
                    halign = "center";
                    valign = "center";
                }
            ];
        };
    };

    services.hypridle = {
        enable = true;
        settings = {
            general = {
                lock_cmd = "pidof hyprlock || hyprlock";
                before_sleep_cmd = "loginctl lock-session";
                after_sleep_cmd = "hyprctl dispatch dpms on";
            };

            listener = [
                {
                    timeout = 900;
                    on-timeout = "loginctl lock-session";
                }
                {
                    timeout = 930;
                    on-timeout = "hyprctl dispatch dpms off";
                    on-resume = "hyprctl dispatch dpms on";
                }
                {
                    timeout = 1200;
                    on-timeout = "systemctl suspend";
                }
            ];
        };
    };

    wayland.windowManager.hyprland = {
        enable = true;
        configType = "hyprlang";
        settings = {
            "$mainMod" = "SUPER";
            "$terminal" = "kitty";
            "$browser" = "firefox";
            "$fileManager" = "files";
            "$menu" = "~/.config/hypr/rofi.sh";
            
            general = {
                gaps_in = 5;
                gaps_out = 20;
                border_size = 5;
                "col.active_border" = "rgb(${config.lib.stylix.colors.base0B})";
                "col.inactive_border" = "rgba(${config.lib.stylix.colors.base02}80)";
                resize_on_border = false;
                allow_tearing = false;
                layout = "dwindle";
            };

            cursor = {
                no_warps = true;
            };
            
            exec-once = [
                "swaybg -i ${config.stylix.image}"
                "waybar -b mainBar"
                "[workspace special:magic silent] obsidian"
                "[workspace 10 silent] keepassxc"
            ];
    
            decoration = {
                rounding = 0;
                active_opacity = 1;
                inactive_opacity = 1;
                shadow = {
                    enabled = true;
                    range = 4;
                    render_power = 3;
                    color = "rgba(1a1a1aee)";
                };

                blur = {
                    enabled = true;
                    size = 3;
                    passes = 1;
                    vibrancy = 0.1696;
                };
            };

            animations = {
                enabled = true;
                bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
                animation = [
                    "windows, 1, 7, myBezier"
                    "windowsOut, 1, 7, default, popin 80%"
                    "border, 1, 10, default"
                    "borderangle, 1, 8, default"
                    "fade, 1, 7, default"
                    "workspaces, 1, 6, default"
                ];
            };
            
            dwindle = {
                preserve_split = true;
            };

            master = {
                new_status = "master";
            };

            misc = {
                force_default_wallpaper = 1;
                disable_hyprland_logo = true;
            };

            input = {
                kb_layout = "us";
                kb_options = "caps:escape";
                follow_mouse = 1;
                touchpad = {
                    natural_scroll = true;
                };
            };

            gesture = "3, horizontal, workspace";

            bindm = [
                # Move/resize windows with mainMod + LMB/RMB and dragging
                "$mainMod, mouse:272, movewindow"
                "$mainMod, mouse:273, resizewindow"
            ];

            bind = [
                "$mainMod, RETURN, exec, $terminal"
                "$mainMod, BACKSLASH, exec, $browser"
                "$mainMod SHIFT, P, exec, $browser --private-window"
                "$mainMod SHIFT, C, exec, hyprpicker -a"
                "$mainMod, O, exec, [workspace special:magic silent] obsidian"
                "$mainMod, C, exec, hyprlock"

                "$mainMod, Q, killactive,"
                "$mainMod&Shift_L, Q, exit,"
                "$mainMod, E, exec, $fileManager"
                "$mainMod, V, togglefloating,"
                "$mainMod, R, exec, $menu"
                "$mainMod, P, pseudo," # dwindle
                "$mainMod, SPACE, layoutmsg, togglesplit" # dwindle

                # Move focus with mainMod + vim movement
                "$mainMod, h, movefocus, l"
                "$mainMod, l, movefocus, r"
                "$mainMod, k, movefocus, u"
                "$mainMod, j, movefocus, d"

                # Move workspace with arrow keys
                "$mainMod, RIGHT, workspace, e+1"
                "$mainMod, LEFT, workspace, e-1"
                "$mainMod SHIFT, LEFT, movetoworkspace, e-1"
                "$mainMod SHIFT, RIGHT, movetoworkspace, e+1"

                # Switch workspaces with mainMod + [0-9]
                "$mainMod, 1, workspace, 1"
                "$mainMod, 2, workspace, 2"
                "$mainMod, 3, workspace, 3"
                "$mainMod, 4, workspace, 4"
                "$mainMod, 5, workspace, 5"
                "$mainMod, 6, workspace, 6"
                "$mainMod, 7, workspace, 7"
                "$mainMod, 8, workspace, 8"
                "$mainMod, 9, workspace, 9"
                "$mainMod, 0, workspace, 10"

                # toggle fullscreen
                "SUPER,F,fullscreen"

                # Move active window to a workspace with mainMod + SHIFT + [0-9]
                "$mainMod SHIFT, 1, movetoworkspace, 1"
                "$mainMod SHIFT, 2, movetoworkspace, 2"
                "$mainMod SHIFT, 3, movetoworkspace, 3"
                "$mainMod SHIFT, 4, movetoworkspace, 4"
                "$mainMod SHIFT, 5, movetoworkspace, 5"
                "$mainMod SHIFT, 6, movetoworkspace, 6"
                "$mainMod SHIFT, 7, movetoworkspace, 7"
                "$mainMod SHIFT, 8, movetoworkspace, 8"
                "$mainMod SHIFT, 9, movetoworkspace, 9"
                "$mainMod SHIFT, 0, movetoworkspace, 10"

                # special workspace
                "$mainMod, S, togglespecialworkspace, magic"
                "$mainMod ALT, S, movetoworkspace, special:magic"

                # Screenshots
                "$mainMod SHIFT, S, exec, grimblast copy area"
                "$mainMod ALT SHIFT, S, exec, grimblast save area"
                ", PRTSCR, exec, grimblast copy"

                # Scroll through existing workspaces with mainMod + scroll
                "$mainMod, mouse_down, workspace, e+1"
                "$mainMod, mouse_up, workspace, e-1"


                # Waybar
                "$mainMod, M, exec, pkill -SIGUSR1 waybar"
                "$mainMod, W, exec, pkill -SIGUSR2 waybar"

                # Brightness Controls
                ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
                ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"

                # Audio Controls
                ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
                ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
                ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"

                # Media Controls
                ", XF86AudioPlay, exec, playerctl play-pause"
                ", XF86AudioNext, exec, playerctl next"
                ", XF86AudioPrev, exec, playerctl previous"
            ];
            windowrule = [
                "suppress_event maximize, match:class .*"
                "workspace special:magic silent, match:class ^(obsidian|Obsidian)$"
                "float on, match:class ^(org.keepassxc.KeePassXC)$"
                "size 900 700, match:class ^(org.keepassxc.KeePassXC)$"
            ];
        };
    };
}
