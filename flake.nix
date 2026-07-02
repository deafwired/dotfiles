{
    description = "System conf";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        
        stylix = {
            url = "github:danth/stylix/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-alien.url = "github:thiagokokada/nix-alien";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";

        copyparty.url = "github:9001/copyparty";
    };
    
    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, copyparty, ...}@inputs:
        let
            system = "x86_64-linux";

            mkHome = device: home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.${system};
                extraSpecialArgs = { inherit device inputs; };
                modules = [
                    inputs.stylix.homeModules.stylix
                    ./home-manager/home.nix
                ];
            };
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
                    inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
                    inputs.stylix.nixosModules.stylix
                    ./nixos/laptop.nix
                ];
            };

            nixosConfigurations.artemis  = nixpkgs.lib.nixosSystem {
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
                    ({ ... }: {
                        nixpkgs.overlays = [ (import ./nixos/overlays/spotx.nix) ];
                        environment.systemPackages = with self.inputs.nix-alien.packages.${system}; [
                            nix-alien
                        ];
                        programs.nix-ld.enable = true;
                    })
                    inputs.stylix.nixosModules.stylix
                    ./nixos/artemis.nix
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
                    })
                    ./nixos/server.nix
                ];
            };

            homeConfigurations = {
                matt = mkHome "default";
                laptop = mkHome "laptop";
                artemis = mkHome "artemis";
                server = mkHome "server";
            };
        };
}
