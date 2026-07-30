{ inputs, ... }:

{
    imports = [ inputs.copyparty.nixosModules.default ];

    nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

    services.copyparty = {
        enable = true;
        accounts = {
            matt.passwordFile = "/data/keys/matt_password";
        };

        volumes = {
            "/" = {
                path = "/data/copyparty/misc";
                access = {
                    r = "*";
                    rwmda = [ "matt" ];
                };
            };
            "/videos" = {
                path = "/data/copyparty/videos";
                access = {
                    r = "*";
                    rwmda = [ "matt" ];
                };
            };
            "/priv" = {
                path = "/data/copyparty/private";
                access = {
                    rwmda = [ "matt" ];
                };
            };
        };
    };
}
