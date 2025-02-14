{ pkgs, ...}: {
    nixpkgs.config = {
        allowUnfree = true;
    };
    environment.systemPackages = with pkgs; [
        wget
        pulseaudio
        fastfetch
        vlc
        obsidian
        vscode
        usbimager
        steam-run
        nss
        zed-editor
        filezilla
        kmonad
        home-manager
        qbittorrent
        libreoffice-qt6
    ];

    fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
            fira-code
            fira-code-symbols
            (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
        ];
    };
}
