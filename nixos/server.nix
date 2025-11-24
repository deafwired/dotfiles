# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, pkgs-unstable, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
		./server-hardware.nix
        ./modules/server-bundle.nix
		];

# Bootloader.
	boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/nvme0n1";
	boot.loader.grub.useOSProber = true;
    boot.swraid.enable = true;
    boot.swraid.mdadmConf = ''
         ARRAY /dev/md0 metadata=1.2 UUID=a9c3123f:32a36065:887fb86f:b1d74c50   
    '';



	nix.settings.experimental-features = ["nix-command" "flakes"];

	networking.hostName = "server"; # Define your hostname.
    networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 8787 5030 50300 2283 25565 3000 8080 ];
    };
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
    networking = {
        networkmanager.enable = true;
    };

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

    # default editor
    environment.variables = { EDITOR = "vim"; };
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    hardware.nvidia.open = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm = {
        enable = true;
        autoSuspend = false;
    };
    services.xserver.desktopManager.gnome.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    # Mounting drives
    fileSystems."/data" = {
        device = "/dev/disk/by-uuid/572ad98a-3476-45ad-9054-d3b698d88582";
        fsType = "ext4";
        options = [ "nofail" ];
    };

    # Syncthing
    services.syncthing = {
        enable = true;
        group = "users";
        user = "matt";
        dataDir = "/home/matt/syncthing";
        configDir = "/home/matt/.config/syncthing";
        settings = {
            devices = {
                "MattsPhone" = { id = "HJTHW5F-MXLEMOB-SBHOO2E-4PFDNU7-RM7DPXN-67MABS7-KB3CKWN-G25QEQI";};
                "coolpc" = { id = "IZODFBD-RAJ34PP-IQQOROC-RN7POCA-ZZMNCE2-GBSTNSZ-3H6BBP4-QI5BHQZ";};
                "laptop" = { id = "BKZMWUW-BUXL7Z5-MTJ4QDJ-DAZ43JX-QBKBJGQ-O6IQMR2-2TEDSW7-QTDZTA5";};
            };
            folders = {
                "Music" = {
                    path = "/data/Music";
                    devices = ["coolpc" "MattsPhone"];
                    id = "musicROCKS";
                };
            };
        };
    };

    services.jellyfin = {
        enable = true;
        dataDir = "/data/jellyfin";
        user = "matt";
    };

    # Slskd
    services.slskd = {
        enable = true;
        user = "matt";
        group = "users";
        openFirewall = true;
        settings = {
            shares = {
                directories = ["/data/Music"];
            };
        };
        domain = "127.0.0.1";
        environmentFile = "/home/matt/.config/slskd";
    };
    users.groups.media = {};
    systemd.services.slskd.serviceConfig.ProtectHome = lib.mkForce "read-only";

    # Factorio
    services.factorio = {
        enable = true;
        openFirewall = true;
        port = 25565;
        saveName = "space";
        package = pkgs-unstable.factorio-headless;
    };

    # Immich
    services.immich = {
        enable = true;
        package = pkgs.immich;
        host = "0.0.0.0";
        openFirewall = true;
        mediaLocation = "/data/immich";
    };
    users.users.immich.extraGroups = [ "video" "render" ];

    # configuring open ssh to a different port  
    services.openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
        ports = [ 8787 ];
    };

    # cron
    services.cron = {
        enable = true;
    };

    # grafana
    services.grafana = {
        enable = true;
        settings = {
            server = {
                http_addr = "0.0.0.0";
                http_port = 3000;
                domain = "deafwired.dev";
            };
        };
    };

    # cloudflared
    services. cloudflared = {
        enable = true;
        tunnels = {
            "fb3f22e6-b732-4d36-bbc6-a4de3740a58c" = {
                credentialsFile = "/var/lib/home.json";
                ingress = {
                    "slskd.deafwired.dev" = {
                        service = "http://localhost:5030";
                    };
                    "immich.deafwired.dev" = {
                        service = "http://localhost:2283";
                    };
                    "jellyfin.deafwired.dev" = {
                        service = "http://localhost:8096";
                    };
                    "mc.deafwired.dev" = {
                        service = "tcp://localhost:25565";
                    };
                    "share.deafwired.dev" = {
                        service = "http://localhost:3923";
                    };
                    "torrent.deafwired.dev" = {
                        service = "http://localhost:8080";
                    };
                    "wishlist.deafwired.dev" = {
                            service = "http://localhost:3456";
                    };
                };
                default = "http_status:404";
            };
        };
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    users.users.matt = {
        isNormalUser = true;
        description = "matt";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
            rustup
            gcc
            home-manager
            screen
            beets
        ];
    };


    # Install firefox.
    programs.firefox.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # fish shell
    programs.fish.enable = true;  
    users.defaultUserShell = pkgs.fish;

    environment.systemPackages = with pkgs; [
        vim
        git
        neovim
        mdadm
        # cloudflared
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.11"; # Did you read the comment?

}
