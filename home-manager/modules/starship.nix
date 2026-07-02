{ config, ...}: {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "[╭╴](238)$env_var$all[╰─](238)$character";
      character = {
        success_symbol = "[>](238)";
        error_symbol = "[>](#ff0000)";
      };
      env_var = {
        STARSHIP_DISTRO = {
          format = "[$env_value](bold white)";
          variable = "STARSHIP_DISTRO";
          disabled = false;
        };
      };
      username = {
        style_user = "white bold";
        style_root = "black bold";
        format = "[$user]($style) ";
        disabled = false;
        show_always = true;
      };
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        home_symbol = " ~";
        style = "${config.lib.stylix.colors.withHashtag.base0B}";
        read_only_style = "197";
        read_only = "  ";
        format = "@ [$path]($style)[$read_only]($read_only_style) ";
      };
      git_branch = {
        symbol = "󰌾 ";
        format = "on [$symbol$branch]($style) ";
        truncation_length = 4;
        truncation_symbol = "…/";
        style = "bold green";
      };
      git_status = {
        format = "[\($all_status$ahead_behind\)]($style) ";
        style = "bold green";
        conflicted = "🏳";
        up_to_date = " ";
        untracked = " ";
        ahead = "⇡$count";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
        behind = "⇣$count";
        stashed = "󰏗 ";
        modified = " ";
        staged = "[++\($count\)](green)";
        renamed = "󰖷 ";
        deleted = " ";
      };
      docker_context = {
        format = "via [󰡨 $context](bold blue) ";
      };
      python = {
        symbol = " ";
        python_binary = "python3";
      };
      nodejs = {
        format = "via [󰎙 $version](bold green) ";
        disabled = true;
      };
      container = {
        disabled = true;
      };
      battery = {
          disabled = true;
      };
    };
  };
}
