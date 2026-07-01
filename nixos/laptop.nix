#68292E Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
            ./hardware-laptop.nix
            ./packages-laptop.nix
            ./modules/laptop-bundle.nix
        ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # experimental features
    nix.settings.experimental-features = ["nix-command" "flakes"];

    networking.hostName = "laptop"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "America/New_York";

    # Select internationalisation properties.
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

    # Enable the X11 windowing system.

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
    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    # programs.hyprland.enable = true;
    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    hardware.graphics.enable32Bit = true;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = false;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    services.blueman.enable = true;
    hardware.bluetooth = {
        enable = true;
        settings = {
                General.Experimental = true;
        };
    };

    # Enable touchpad support (enabled default in most desktopManager).
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

    # Define a user account. Don't forget to set a password with ‘passwd’.
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


    # Install firefox.
    programs.firefox.enable = true;
    programs.fish.enable = true;

    programs.nix-ld.enable = true;
    # Allow unfree packages
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

    # List services that you want to enable:
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

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.11"; # Did you read the comment?

}
