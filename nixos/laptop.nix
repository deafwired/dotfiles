#68292E Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
            ./laptop-hardware.nix
            ./laptop-packages.nix
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
        enable = true;
        desktopManager = {
            gnome.enable = true;
        };
        displayManager = {
            gdm.enable = true;
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
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    services.blueman.enable = true;
    hardware.bluetooth.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.matt = {
        isNormalUser = true;
        shell = pkgs.fish;
        description = "matt";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
            vesktop
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
            anki
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


    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:
    services.syncthing = {
        enable = true;
        user = "matt";
        dataDir = "/home/matt/syncthing";
        configDir = "/home/matt/.config/syncthing";
        settings = {
            devices = {
                "MattsPhone" = { id = "HJTHW5F-MXLEMOB-SBHOO2E-4PFDNU7-RM7DPXN-67MABS7-KB3CKWN-G25QEQI";};
                "coolpc" = { id = "IZODFBD-RAJ34PP-IQQOROC-RN7POCA-ZZMNCE2-GBSTNSZ-3H6BBP4-QI5BHQZ";};
            };
            folders = {
                "Documents" = {
                    path = "/home/matt/Documents";
                };
                "keepass" = {
                    path = "/home/matt/Documents/Passwords"; 
                    devices = ["MattsPhone" "coolpc"];
                };
                "Notes" = {
                    path = "/home/matt/Documents/Notes";
                    devices = ["MattsPhone" "coolpc"];
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
