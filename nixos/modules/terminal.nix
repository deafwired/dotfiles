{ pkgs, pkgs-unstable, ...}: {
    environment.systemPackages = with pkgs; [
        # neovim
        pkgs-unstable.claude-code
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
