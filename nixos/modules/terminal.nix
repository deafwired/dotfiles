{ pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        neovim
        git
        fish
        unzip
        wireshark
        nmap
        home-manager
        lftp
        libreoffice-qt6
    ];
}
