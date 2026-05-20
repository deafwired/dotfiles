{ pkgs, ... }:
{
    programs.niri.enable = true;

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
