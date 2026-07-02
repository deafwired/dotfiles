{ config, ... }:
{
    # Symlink the rofi launcher script so both Hyprland and Niri can use it
    home.file.".config/niri/rofi.sh".source = ./rofi.sh;

    home.file.".config/niri/config.kdl".text = ''
        input {
            keyboard {
                xkb {
                    layout "us"
                    options "caps:escape"
                }
            }

            touchpad {
                natural-scroll
            }

            focus-follows-mouse
            workspace-auto-back-and-forth
        }

        cursor {
            xcursor-theme "${config.stylix.cursor.name}"
            xcursor-size ${toString config.stylix.cursor.size}
        }

        layout {
            focus-ring {
                active-color "${config.lib.stylix.colors.withHashtag.base0B}"
                inactive-color "${config.lib.stylix.colors.withHashtag.base02}"
            }
        }

        spawn-sh-at-startup "swaybg -i ${config.stylix.image}"
        spawn-at-startup "waybar"

        binds {
            Mod+Return { spawn "kitty"; }
            Mod+Backslash { spawn "firefox"; }
            Mod+Shift+P { spawn "firefox" "--private-window"; }
            Mod+Shift+C { spawn "hyprpicker" "-a"; }
            Mod+O { spawn "obsidian"; }
            Mod+C { spawn "hyprlock"; }

            Mod+Q { close-window; }
            Mod+Shift+Q { quit skip-confirmation=true; }
            Mod+E { spawn "files"; }
            Mod+V { toggle-window-floating; }
            Mod+R { spawn "~/.config/niri/rofi.sh"; }

            Mod+H { focus-column-left; }
            Mod+L { focus-column-right; }
            Mod+J { focus-workspace-down; }
            Mod+K { focus-workspace-up; }

            Mod+Left { focus-column-left; }
            Mod+Right { focus-column-right; }
            Mod+Up { focus-workspace-up; }
            Mod+Down { focus-workspace-down; }

            Mod+1 { focus-workspace 1; }
            Mod+2 { focus-workspace 2; }
            Mod+3 { focus-workspace 3; }
            Mod+4 { focus-workspace 4; }
            Mod+5 { focus-workspace 5; }
            Mod+6 { focus-workspace 6; }
            Mod+7 { focus-workspace 7; }
            Mod+8 { focus-workspace 8; }
            Mod+9 { focus-workspace 9; }
            Mod+0 { focus-workspace 10; }

            Mod+Shift+1 { move-column-to-workspace 1; }
            Mod+Shift+2 { move-column-to-workspace 2; }
            Mod+Shift+3 { move-column-to-workspace 3; }
            Mod+Shift+4 { move-column-to-workspace 4; }
            Mod+Shift+5 { move-column-to-workspace 5; }
            Mod+Shift+6 { move-column-to-workspace 6; }
            Mod+Shift+7 { move-column-to-workspace 7; }
            Mod+Shift+8 { move-column-to-workspace 8; }
            Mod+Shift+9 { move-column-to-workspace 9; }
            Mod+Shift+0 { move-column-to-workspace 10; }

            Mod+Shift+S { screenshot; }
            Print { screenshot-screen; }

            Mod+M { spawn "pkill" "-SIGUSR1" "waybar"; }
            Mod+W { spawn "pkill" "-SIGUSR2" "waybar"; }

            XF86MonBrightnessUp { spawn "brightnessctl" "set" "+10%"; }
            XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }

            XF86AudioRaiseVolume { spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "+5%"; }
            XF86AudioLowerVolume { spawn "pactl" "set-sink-volume" "@DEFAULT_SINK@" "-5%"; }
            XF86AudioMute { spawn "pactl" "set-sink-mute" "@DEFAULT_SINK@" "toggle"; }

            XF86AudioPlay { spawn "playerctl" "play-pause"; }
            XF86AudioNext { spawn "playerctl" "next"; }
            XF86AudioPrev { spawn "playerctl" "previous"; }
        }

        window-rule {
            match app-id=r#"^org\.keepassxc\.KeePassXC$"#
            open-floating true
            default-column-width { fixed 900; }
            default-window-height { fixed 700; }
        }
    '';
}
