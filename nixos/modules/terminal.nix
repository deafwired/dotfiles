{ pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        # neovim
        ripgrep
        git
        fish
        unzip
        wireshark
        nmap
        home-manager
        lftp
        libreoffice-qt6
        grc
    ];
}
