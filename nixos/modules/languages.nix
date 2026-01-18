{ pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        gcc
        rustc
        cargo
        lua
        dotnet-sdk_9
        jre25_minimal
        processing
        texliveBasic
        racket
    ];
}
