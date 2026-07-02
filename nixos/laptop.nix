{ config, pkgs, pkgs-unstable, ... }:

{
    imports =
        [
            ./hardware-laptop.nix
            ./packages-laptop.nix
            ./modules/laptop-bundle.nix
        ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix.settings.experimental-features = ["nix-command" "flakes"];

    networking.hostName = "laptop";
    networking.networkmanager.enable = true;

    time.timeZone = "America/New_York";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    services = {
        desktopManager = {
            gnome.enable = true;
        };
        greetd = {
            enable = true;
            settings = {
                default_session = {
                    user = "greeter";
                    command = "${pkgs.tuigreet}/bin/tuigreet --issue --time --remember --remember-session --cmd Hyprland";
                };
            };
        };
    };

    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    # programs.hyprland.enable = true;

    services.printing.enable = true;

    hardware.graphics.enable32Bit = true;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = false;
        pulse.enable = true;
    };

    services.blueman.enable = true;
    hardware.bluetooth = {
        enable = true;
        settings = {
                General.Experimental = true;
        };
    };

    services.libinput.enable = true;

    services.fwupd.enable = true;
    services.fwupd.package = (import (builtins.fetchTarball {
                url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
                sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
    }) { system = pkgs.stdenv.hostPlatform.system; }).fwupd;

    environment.etc.issue.text = "
        _-_.
     _-',^. `-_.
 ._-' ,'   `.   `-_ 
!`-_._________`-':::
!   /\        /\::::
;  /  \      /..\:::
! /    \    /....\::
!/      \  /......\:
;--.___. \/_.__.--;; 
 '-_    `:!;;;;;;;'
    `-_, :!;;;''
        `-!'        
    ";

    users.users.matt = {
        isNormalUser = true;
        shell = pkgs.fish;
        description = "matt";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
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
            neovim-remote
            android-studio
            android-tools
            pavucontrol
            forge-mtg
            arduino-ide
            pandoc
        ];
    };


    programs.firefox.enable = true;
    programs.fish.enable = true;

    programs.nix-ld.enable = true;
    nixpkgs.config.allowUnfree = true;

    # trying to get drexel wifi to work
    nixpkgs.config.packageOverrides = pkgs: rec {
        wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {patches = attrs.patches ++ [./dragonfly3.patch];});
    };

    # Garbage Collection
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    services.syncthing = {
        enable = true;
        user = "matt";
        dataDir = "/home/matt/syncthing";
        configDir = "/home/matt/.config/syncthing";
        settings = {
            devices = {
                "MattsPhone" = { id = "HJTHW5F-MXLEMOB-SBHOO2E-4PFDNU7-RM7DPXN-67MABS7-KB3CKWN-G25QEQI";};
                "artemis" = { id = "M574L33-U6QBYGE-7ZBJAEF-HEQKIVM-CFB5CU7-BZGBCZJ-3L2YYNG-NMR26AM";};
                "server" = { id = "T3F7QXJ-CETLFWQ-TAJATCU-TLHM2WC-VZVUXIP-MCZZNRT-4ASUBME-K73BPQT";};
            };
            folders = {
                "Documents" = {
                    path = "/home/matt/Documents";
                };
                "keepass" = {
                    path = "/home/matt/Documents/Passwords"; 
                    devices = ["MattsPhone" "artemis" "server"];
                };
                "Notes" = {
                    path = "/home/matt/Documents/Notes";
                    devices = ["MattsPhone" "artemis"];
                };
            };
            gui = {
                user = "DeafWired";
                password = "D0Y0urW0rk!";
            };
        };
    };

    services.openssh.enable = true;

    system.stateVersion = "24.11";
}
