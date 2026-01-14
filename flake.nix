{
    description = "System conf";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        
        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        
        stylix = {
            url = "github:danth/stylix/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixvim = {
            url = "github:nix-community/nixvim/nixos-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        copyparty.url = "github:9001/copyparty";
    };
    
    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, copyparty, ...}@inputs:
        let
            system = "x86_64-linux";
        in {
            nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    pkgs-stable = import nixpkgs {
                        inherit system;
                        config.allowUnfree = true;
                    };
                    pkgs-unstable = import nixpkgs-unstable {
                        inherit system;
                        config.allowUnfree = true;
                    };
                    inherit inputs system;
                };
                modules = [
                    ./nixos/laptop.nix
                    inputs.nixvim.nixosModules.nixvim
                ];
            };

            nixosConfigurations.server = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    pkgs-stable = import nixpkgs {
                        inherit system;
                        config.allowUnfree = true;
                    };
                    pkgs-unstable = import nixpkgs-unstable {
                        inherit system;
                        config.allowUnfree = true;
                    };
                    inherit inputs system;
                };
                modules = [
                    copyparty.nixosModules.default
                    ({ pkgs, ... }: {
                        nixpkgs.overlays = [ copyparty.overlays.default ];
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
                                        rwda = [ "matt" ];
                                    };
                                };
                                "/videos" = {
                                    path = "/data/copyparty/videos";
                                    access = {
                                        r = "*";
                                        rwda = [ "matt" ];
                                    };
                                };
                                "/priv" = {
                                    path = "/data/copyparty/private";
                                    access = {
                                        rwda = [ "matt" ];
                                    };
                                };
                            };
                        };
                    })
                    ./nixos/server.nix
                ];
            };

            homeConfigurations.matt = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.${system};
                modules = [ 
                    ./home-manager/home.nix
                ];
            };
        };
}
