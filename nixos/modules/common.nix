{ pkgs, pkgs-unstable, ... }: {
    imports = [
        ./hotspot-proxy.nix
    ];

    # forge-mtg-snapshot builds live from Forge's master branch and needs
    # network access during the build (no fixed-output hash), so it opts
    # out of the sandbox via __noChroot. That opt-out only works when the
    # daemon allows it.
    nix.settings.sandbox = "relaxed";

    environment.systemPackages = with pkgs; [
        vesktop
        # discord
        wget
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
        obs-studio
        calibre
        foliate
        onlyoffice-desktopeditors
        (pkgs-unstable.callPackage ../packages/forge-mtg-snapshot.nix { })
        prismlauncher
    ];

    fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
            fira-code
            fira-code-symbols
            pixel-code
            nerd-fonts.symbols-only
        ];
    };

    programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
    };

    users.users.matt.packages = with pkgs; [
        wofi
        waybar
        wttrbar
        chromium
        steam
        keepassxc
        tealdeer
        gh
        pkgs-unstable.itch
        unityhub
        (callPackage ../packages/nvimunity.nix { })
        neovim-remote
        android-tools
        pavucontrol
    ];
}
