{ pkgs, ...}: {
    nixpkgs.config = {
        allowUnfree = true;
    };
    environment.systemPackages = with pkgs; [
        pulseaudio
        orca-slicer
        jetbrains.idea
        btop
        zoom-us
        git-lfs
    ];
}
