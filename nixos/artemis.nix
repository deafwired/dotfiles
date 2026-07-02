{ config, pkgs, pkgs-unstable, ... }:

{
    imports =
        [
            ./hardware-artemis.nix
            ./packages-artemis.nix
            ./modules/artemis-bundle.nix
        ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix.settings.experimental-features = ["nix-command" "flakes"];

    networking.hostName = "artemis";
    networking.networkmanager.enable = true;

    fileSystems."/mnt/hdd1" = {
        device = "/dev/disk/by-uuid/7E20EF7A20EF3833";
        fsType = "ntfs3";
        options = [ "nofail" "x-systemd.automount" ];
    };

    fileSystems."/mnt/hdd2" = {
        device = "/dev/disk/by-uuid/580A5B070A5AE214";
        fsType = "ntfs3";
        options = [ "nofail" "x-systemd.automount" ];
    };

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
        displayManager = {
            gdm.enable = true;
        };
    };

    services.gnome.gnome-remote-desktop.enable = true;
    programs.dconf = {
        enable = true;
        profiles.user.databases = [
            {
                settings = {
                    "org/gnome/desktop/interface" = {
                        color-scheme = "prefer-dark";
                    };
                };
            }
        ];
    };

    # boot.kernelParams = [
    #   "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    #   "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    # ];

    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };


    # programs.hyprland.enable = true;
    programs.niri.enable = true;

    services.printing.enable = true;

    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.extraConfig = {
            "microphone-volume" = {
                "monitor.alsa.rules" = [
                {
                    matches = [
                    { "node.name" = "alsa_input.usb-Generic_Blue_Microphones_LT_2417SQ00259862900046_111000-00.analog-stereo"; }
                    ];
                    actions = {
                        update-props = {
                            "node.volume" = 1.25;
                            "node.lock-volume" = true;
                        };
                    };
                }
                ];
            };
            "disable-flat-volumes" = {
                "pulse.properties" = {
                    "pulse.flat-volumes" = false;
                };
            };
        };

    };

    services.blueman.enable = true;
    hardware.bluetooth.enable = true;

    services.libinput.enable = true;

    # XDG Desktop Portal for screen sharing on Wayland
    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-gnome
            xdg-desktop-portal-wlr
        ];
        configPackages = with pkgs; [
            xdg-desktop-portal-gnome
        ];
        config.common.default = [ "gnome" ];
        config.common.screencast-portal = [ "wlr" ];
    };

    # Fingerprint shenanigans
    services.fwupd.enable = true;
    services.fwupd.package = (import (builtins.fetchTarball {
                url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
                sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
    }) { system = pkgs.stdenv.hostPlatform.system; }).fwupd;

    security.pam.services.sudo.fprintAuth = false;
    security.pam.services.hyprlock.fprintAuth = false;
    security.pam.services.gdm-fingerprint.fprintAuth = false;

    users.users.matt = {
        isNormalUser = true;
        shell = pkgs.fish;
        description = "matt";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
            discord
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
            android-tools
            pavucontrol
            piper
            spotify
            onlyoffice-desktopeditors
            zoom-us
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

    services.flatpak.enable = true;
    services.ratbagd.enable = true;

    services.syncthing = {
        enable = true;
        user = "matt";
        dataDir = "/home/matt/syncthing";
        configDir = "/home/matt/.config/syncthing";
        settings = {
            devices = {
                "MattsPhone" = { id = "HJTHW5F-MXLEMOB-SBHOO2E-4PFDNU7-RM7DPXN-67MABS7-KB3CKWN-G25QEQI";};
                "laptop" = { id = "BKZMWUW-BUXL7Z5-MTJ4QDJ-DAZ43JX-QBKBJGQ-O6IQMR2-2TEDSW7-QTDZTA5";};
            };
            folders = {
                "keepass" = {
                    path = "/home/matt/Documents/Passwords"; 
                    devices = ["MattsPhone" "laptop"];
                };
                "Notes" = {
                    path = "/home/matt/Documents/Notes";
                    devices = ["MattsPhone" "laptop"];
                };
                "Books" = {
                        path = "/home/matt/Books";
                        devices = ["MattsPhone" "laptop"];
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
