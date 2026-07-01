{ config, pkgs, ... }: {
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
                font-family: "Pixel Code";
                font-size: 16px;
            }

            window {
                background-color: transparent;
                border-radius: 0;
            }

            #outer-box {
                background-color: #272e33;
                border: 5px solid #a7c080;
                padding: 0;
            }

            #input {
                background-color: #2e383c;
                color: #d3c6aa;
                border: none;
                border-bottom: 2px solid #414b50;
                border-radius: 0;
                padding: 10px;
                margin: 0;
                box-shadow: none;
            }

            #inner-box {
                background-color: #272e33;
            }

            #scroll {
                background-color: #272e33;
                margin: 0;
            }

            #text {
                color: #d3c6aa;
                padding: 4px 8px;
            }

            #entry {
                background-color: #272e33;
                border-radius: 0;
                padding: 6px 10px;
            }

            #entry:selected {
                background-color: #2e383c;
            }

            #entry:selected #text {
                color: #a7c080;
            }

            #img {
                margin-right: 8px;
            }
        '';
    };
}
