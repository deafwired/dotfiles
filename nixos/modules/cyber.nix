{ pkgs, ... }:
{
    
    environment.systemPackages = with pkgs; [
        pkgs.burpsuite
        ffuf
    ];
}
