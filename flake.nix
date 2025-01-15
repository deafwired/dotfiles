{
    description = "System conf";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
        
        home-manager = {
            url = "github:nix-community/home-manager/release-24.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    
    outputs = { self, nixpkgs, home-manager, ...}@inputs:
        let
            system = "x86_64-linux";
        in {
            nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
                specialArgs = {
                    pkgs-stable = import nixpkgs {
                        inherit system;
                        config.allowUnfree = true;
                    };
                    inherit inputs system;
                };
                modules = [
                    ./nixos/configuration.nix
                ];
            };

            homeConfiguration.matt = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.${system};
                modules = [ ./home-manager/home.nix ];
            };
        };
}
