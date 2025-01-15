{ pkgs, ... }:
{
    programs.hyprland.enable = true;
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
