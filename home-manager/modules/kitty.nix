{ config, pkgs, ...}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode";
      size = 20;
    };
    settings = {
        background = "#000000";
        confirmOsWindowClose = false;
        disableLigatures = "never";
    # Symbol maps
    symbolMap = [
      "U+E5FA-U+E6AC Symbols Nerd Font" # Seti-UI + Custom
      "U+E700-U+E7C5 Symbols Nerd Font" # Devicons
      "U+F000-U+F2E0 Symbols Nerd Font" # Font Awesome
      "U+E200-U+E2A9 Symbols Nerd Font" # Font Awesome Extension
      "U+F0001-U+F1AF0 Symbols Nerd Font" # Material Design Icons
      "U+E300-U+E3E3 Symbols Nerd Font" # Weather
      "U+F400-U+F532,U+2665,U+26A1 Symbols Nerd Font" # Octicons
      "U+E0A0-U+E0A2,U+E0B0-U+E0B3 Symbols Nerd Font" # Powerline Symbols
      "U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D4 Symbols Nerd Font" # Powerline Extra Symbols
      "U+23FB-U+23FE,U+2B58 Symbols Nerd Font" # IEC Power Symbols
      "U+F300-U+F32F Symbols Nerd Font" # Font Logos
      "U+E000-U+E00A Symbols Nerd Font" # Pomicons
      "U+EA60-U+EBEB Symbols Nerd Font" # Codicons
      "U+E276C-U+E2771 Symbols Nerd Font" # Heavy Angle Brackets
      "U+2500-U+259F Symbols Nerd Font" # Box Drawing
      # nonicons contains specific symbols
      "U+F102,U+F116-U+F118,U+F12F,U+F13E,U+F1AF,U+F1BF,U+F1CF,U+F1FF,U+F20F,U+F21F-U+F220,U+F22E-U+F22F,U+F23F,U+F24F,U+F25F nonicons"
    ];
    };
  };
}
