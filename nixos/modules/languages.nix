{ pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        gcc
        rustc
        cargo
        lua
        dotnet-sdk_9
        temurin-jre-bin-23
        processing
        texliveBasic
    ];
}
