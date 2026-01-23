{ config, pkgs, ...}: {
    home.file.".config/hypr/rofi.sh".source = ./rofi.sh;

    wayland.windowManager.hyprland = {
        enable = true;
        settings = {
            "$mainMod" = "SUPER";
            "$terminal" = "kitty";
            "$browser" = "firefox";
            "$menu" = "~/.config/hypr/rofi.sh";
            
            monitor = ",preferred,auto,1";

            env = [
                "GTK_THEME,Adwaita:dark"
                "XCURSOR_SIZE,24"
                "HYPRCURSOR_SIZE,24"
            ];

            general = {
                gaps_in = 5;
                gaps_out = 20;
                border_size = 5;
                "col.active_border" = "rgba(ba071aff)";
                "col.inactive_border" =  "rgba(59595980)";
                resize_on_border = false;
                allow_tearing = false;
                layout = "dwindle";
            };

            cursor = {
                no_warps = true;
            };
            
            exec-once = [
                "swaybg -i ~/Desktop/background.png"
                "waybar"
                "dunst"
                "obsidian"
            ];
    
            decoration = {
                rounding = 10;
                active_opacity = 1;
                inactive_opacity = 0.9;
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
                pseudotile = true;
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
                "$mainMod SHIFT, C, exec, hyprpicker -a"
                "$mainMod, O, exec, obsidian"

                "$mainMod, Q, killactive,"
                "$mainMod&Shift_L, Q, exit,"
                "$mainMod, E, exec, $fileManager"
                "$mainMod, V, togglefloating,"
                "$mainMod, R, exec, $menu"
                "$mainMod, P, pseudo," # dwindle
                "$mainMod, SPACE, togglesplit, # dwindle"

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

                # Example special workspace (scratchpad)
                "$mainMod, S, togglespecialworkspace, magic"

                # Screenshots
                "$mainMod SHIFT, S, exec, grimblast copy area"
                ", PRTSCR, exec, grimblast copy"

                # Scroll through existing workspaces with mainMod + scroll
                "$mainMod, mouse_down, workspace, e+1"
                "$mainMod, mouse_up, workspace, e-1"


                # Waybar
                "$mainMod, M, exec, pkill -SIGUSR1 waybar"
                "$mainMod, W, exec, pkill -SIGUSR2 waybar"

                # Brightness Controls
                ", XF86MonBrightnessUp, exec, brightnessctl set +10% "
                ", XF86MonBrightnessDown, exec, brightnessctl set 10%-" 

                # Audio Controls
                ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
                ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
                ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"

                # Media Controls
                ", XF86AudioPlay, exec, playerctl play-pause"
                ", XF86AudioNext, exec, playerctl next"
                ", XF86AudioPrev, exec, playerctl previous"
            ];
            windowrulev2 = [
                "suppressevent maximize, class:.*"
                "workspace special:magic, class:^(obsidian)$"
                "float, class:^(org.keepassxc.KeePassXC)$"
                "size 900 700, class:^(org.keepassxc.KeePassXC)$"
            ];
        };
    };
}
