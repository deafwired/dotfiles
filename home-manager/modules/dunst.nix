{ config, pkgs, ... }:
{
  # Install dunst so the binary is available to the user
  home.packages = with pkgs; [ dunst ];

  # Ensure the dunstrc is written to the user's config directory
  home.file.".config/dunst/dunstrc" = {
    text = builtins.readFile ./dunstrc;
  };
}
