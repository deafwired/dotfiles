{ pkgs, ...}: {
    environment.systemPackages = with pkgs; [
        # neovim
        claude-code
        ripgrep
        git
        fish
        unzip
        wireshark
        nmap
        home-manager
        lftp
        zoxide
        grc
        zoxide
        lazygit
        htop
        kitty
        zip
        glibcInfo
        man-pages
        starship
    ];
}
