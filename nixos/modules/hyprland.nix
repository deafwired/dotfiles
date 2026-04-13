{ pkgs, ... }:
{
    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;
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
