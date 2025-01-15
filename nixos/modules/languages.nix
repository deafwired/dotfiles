{ pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        gcc
        rustup
        lua
        tmurin-jre-bin-23
        processing
        texliveBasic
    ];
}
