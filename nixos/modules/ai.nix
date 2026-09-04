{ config, pkgs, lib, ...}: {
    services.ollama = {
        enable = true;
        package = lib.mkIf (config.networking.hostName == "artemis") pkgs.ollama-cuda;
    };
}
