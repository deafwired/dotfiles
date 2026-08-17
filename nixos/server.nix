{ lib, config, pkgs, pkgs-unstable, ... }:

{
	imports =
		[
        ./packages-server.nix
		./hardware-server.nix
        ./modules/server-bundle.nix
		];

	boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/nvme0n1";
	boot.loader.grub.useOSProber = true;
    boot.swraid.enable = true;
    boot.swraid.mdadmConf = ''
         ARRAY /dev/md0 metadata=1.2 UUID=a9c3123f:32a36065:887fb86f:b1d74c50   
    '';



	nix.settings.experimental-features = ["nix-command" "flakes"];

    # Weekly automatic NixOS updates
    system.autoUpgrade = {
        enable = true;
        flake = "/home/matt/dotfiles#server";
        dates = "weekly";
        randomizedDelaySec = "45min";
        persistent = true;
        allowReboot = false;
    };

	networking.hostName = "server";
    networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 8787 5030 50300 2283 25565 3000 8080 8083 ];
        allowedUDPPorts = [ 26000 25565 ];
    };
    networking = {
        networkmanager.enable = true;
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

    environment.variables = { EDITOR = "vim"; };

    services.xserver.enable = true;

    services.flatpak.enable = true;
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

    services.displayManager.gdm = {
        enable = true;
        autoSuspend = false;
    };
    services.desktopManager.gnome.enable = true;

    programs.dconf = {
        enable = true;
        profiles.user.databases = [
            {
                settings = {
                    "org/gnome/desktop/interface" = {
                        color-scheme = "prefer-dark";
                        gtk-theme = "Adwaita-dark";
                    };
                };
            }
        ];
    };

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
                "artemis" = { id = "M574L33-U6QBYGE-7ZBJAEF-HEQKIVM-CFB5CU7-BZGBCZJ-3L2YYNG-NMR26AM";};
                "laptop" = { id = "BKZMWUW-BUXL7Z5-MTJ4QDJ-DAZ43JX-QBKBJGQ-O6IQMR2-2TEDSW7-QTDZTA5";};
            };
            folders = {
                "Music" = {
                    path = "/data/Music";
                    devices = ["artemis" "MattsPhone"];
                    id = "musicROCKS";
                };
                "keepass" = {
                    path = "/home/matt/Documents/Passwords";
                    devices = ["MattsPhone" "artemis" "laptop"];
                };
                "Books" = {
                    path = "/data/calibre";
                    devices = ["artemis"];
                };
            };
        };
    };

    services.jellyfin = {
        enable = true;
        dataDir = "/data/jellyfin";
        user = "matt";
    };

    # OctoPrint for the 3D printer connected to this server.
    services.octoprint = {
        enable = true;
        host = "127.0.0.1";
        openFirewall = false;
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
        package = pkgs-unstable.immich;
        host = "0.0.0.0";
        openFirewall = true;
        mediaLocation = "/data/immich";
    };
    users.users.immich.extraGroups = [ "video" "render" ];

    # Calibre-Web Automated
    systemd.tmpfiles.rules = [
        "d /data/calibre 0755 matt users -"
        "Z /data/calibre 0755 matt users -"
        "d /data/calibre-web-automated/config 0755 matt users -"
        "d /data/cwa-ingest 0755 matt users -"
        "d /data/minecraft/stoneblock4 0755 matt users -"
    ];

    virtualisation.podman.enable = true;
    virtualisation.oci-containers.backend = "podman";

    virtualisation.oci-containers.containers.calibre-web-automated = {
        image = "crocodilestick/calibre-web-automated:latest";
        autoStart = true;
        ports = [ "8083:8083" ];
        volumes = [
            "/data/calibre-web-automated/config:/config"
            "/data/cwa-ingest:/cwa-book-ingest"
            "/data/calibre:/calibre-library"
        ];
        environment = {
            PUID = "1000";
            PGID = "100";
            TZ = "America/New_York";
            NETWORK_SHARE_MODE = "false";
        };
        environmentFiles = [
            "/home/matt/.config/calibre-web-automated"
        ];
    };

    # Minecraft: StoneBlock 4 (FTB, NeoForge, MC 1.21.1)
    virtualisation.oci-containers.containers.minecraft-stoneblock4 = {
        image = "itzg/minecraft-server:java21";
        autoStart = true;
        ports = [ "25565:25565" ];
        volumes = [
            "/data/minecraft/stoneblock4:/data"
        ];
        environment = {
            EULA = "TRUE";
            TYPE = "AUTO_CURSEFORGE";
            CF_SLUG = "ftb-stoneblock-4";
            MEMORY = "10G";
            TZ = "America/New_York";
        };
        environmentFiles = [
            "/home/matt/.config/minecraft-stoneblock4"
        ];
    };

    services.openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
        ports = [ 8787 ];
    };

    # cron
    services.cron = {
        enable = true;
    };

    # Home Assistant
    services.home-assistant = {
        enable = true;
        openFirewall = true;
        config = {
            homeassistant = {
                name = "Home";
                time_zone = "America/New_York";
            };
            http = {
                server_port = 8123;
                use_x_forwarded_for = true;
                trusted_proxies = [ "127.0.0.1" "::1" ];
            };
        };
        extraComponents = [
            "zha"
        ];
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
                    "books.deafwired.dev" = {
                        service = "http://localhost:8083";
                    };
                    "octoprint.deafwired.dev" = {
                        service = "http://localhost:5000";
                    };
                    "homeassistant.deafwired.dev" = {
                        service = "http://localhost:8123";
                    };
                    "wishlist.deafwired.dev" = {
                            service = "http://localhost:3456";
                    };
                };
                default = "http_status:404";
            };
        };
    };

    services.printing.enable = true;

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
            pkgs-unstable.beets
            python315
            nodejs_24
        ];
    };


    programs.firefox.enable = true;

    nixpkgs.config.allowUnfree = true;

    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;

    environment.systemPackages = with pkgs; [
        vim
        git
        neovim
        mdadm
        # cloudflared
    ];

    system.stateVersion = "24.11";
}
