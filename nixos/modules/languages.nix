{ pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        gcc
        rustup
        lua
        temurin-jre-bin-23
        processing
        texliveBasic
    ];
}
