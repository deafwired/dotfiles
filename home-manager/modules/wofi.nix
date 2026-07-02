{ config, ... }:
let
    c = config.lib.stylix.colors.withHashtag;
in {
    programs.wofi = {
        enable = true;
        settings = {
            width = "30%";
            height = "40%";
            location = "center";
            show = "drun";
            prompt = ">_";
            filter_rate = 100;
            allow_markup = true;
            no_actions = true;
            halign = "fill";
            orientation = "vertical";
            content_halign = "fill";
            insensitive = true;
            allow_images = true;
            image_size = 32;
            gtk_dark = true;
        };
        style = ''
            * {
                font-family: "${config.stylix.fonts.monospace.name}";
                font-size: ${toString config.stylix.fonts.sizes.desktop}px;
            }

            window {
                background-color: transparent;
                border-radius: 0;
            }

            #outer-box {
                background-color: ${c.base00};
                border: 5px solid ${c.base0B};
                padding: 0;
            }

            #input {
                background-color: ${c.base01};
                color: ${c.base05};
                border: none;
                border-bottom: 2px solid ${c.base02};
                border-radius: 0;
                padding: 10px;
                margin: 0;
                box-shadow: none;
            }

            #inner-box {
                background-color: ${c.base00};
            }

            #scroll {
                background-color: ${c.base00};
                margin: 0;
            }

            #text {
                color: ${c.base05};
                padding: 4px 8px;
            }

            #entry {
                background-color: ${c.base00};
                border-radius: 0;
                padding: 6px 10px;
            }

            #entry:selected {
                background-color: ${c.base01};
            }

            #entry:selected #text {
                color: ${c.base0B};
            }

            #img {
                margin-right: 8px;
            }
        '';
    };
}
