{ config, lib, ... }: {
    programs.lazygit = {
        enable = true;
        settings.gui.theme.activeBorderColor = lib.mkForce [
            config.lib.stylix.colors.withHashtag.base0B
            "bold"
        ];
    };
}
