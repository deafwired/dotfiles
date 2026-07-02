{ config, lib, ... }:
{
    services.dunst = {
        enable = true;
        settings = {
            global = {
                transparency = 0;
                frame_width = 5;
                separator_height = 1;

                origin = "top-right";
                alignment = "right";
                sort = "oldest";
                follow = "mouse";
                offset = "20x20";
                padding = 10;
                corner_radius = 0;
            };

            urgency_low.timeout = 5;
            urgency_normal = {
                timeout = 10;
                frame_color = lib.mkForce config.lib.stylix.colors.withHashtag.base0B;
                highlight = lib.mkForce config.lib.stylix.colors.withHashtag.base0B;
            };
            urgency_critical.timeout = 0;
        };
    };
}
