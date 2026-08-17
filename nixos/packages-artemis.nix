{ pkgs, pkgs-unstable, ...}: {
    nixpkgs.config = {
        allowUnfree = true;
    };
    environment.systemPackages = with pkgs; [
        btop-cuda
        openssl
        blanket
        jellyfin-tui
        parsec-bin
        prismlauncher
    ];
}
