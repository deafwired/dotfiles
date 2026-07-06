{ pkgs, pkgs-unstable, ...}: {
    nixpkgs.config = {
        allowUnfree = true;
    };
    environment.systemPackages = with pkgs; [
        btop-cuda
        openssl
        pkgs-unstable.forge-mtg
        blanket
        foliate
        jellyfin-tui
        parsec-bin
    ];
}
