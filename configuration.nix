# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  #boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot = {
    #kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    #extraModulePackages = [config.boot.kernelPackages.nvidiaPackages];
    kernelPackages = pkgs.linuxPackages_zen;
    #kernelParams = [
    #"nvidia-drm.modset=1"
    #"initcall_blacklist=simpledrm_platform_driver_init"
    #];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
  };

  #GPU stuff
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "steam"
      "steam-original"
      "steam-run"
      "libXNVCtrl"
    ];

  hardware = {
    graphics = {
      enable = true;
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    #Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true; # Show battery level
    };
  };

  networking = {
    hostName = "nixos";
    wireless = {
      enable = true;
      environmentFile = "/etc/secrets/wifi-secrets.env";
      networks = {
        BeeConnected.psk = "@PASS_HOME@";
      };
    };
  };
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Setting nix experimental features on
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    #keyMap = "us-intl";
    useXkbConfig = true; # use xkb.options in tty.
  };

  services.getty.autologinUser = "Thieu";

  # # Greeter
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
  #       user = "greeter";
  #     };
  #   };
  # };
  #
  # # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  # # https://github.com/sjcobb2022/nixos-config/blob/29077cee1fc82c5296908f0594e28276dacbe0b0/hosts/common/optional/greetd.nix
  # systemd.services.greetd.serviceConfig = {
  #   Type = "idle";
  #   StandardInput = "tty";
  #   StandardOutput = "tty";
  #   StandardError = "journal"; # Without this errors will spam on screen
  #   # Without these bootlogs will spam on screen
  #   TTYReset = true;
  #   TTYVHangup = true;
  #   TTYVTDisallocate = true;
  # };

  # Enable Hyprland
  security.pam.services.hyprlock = {};
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
  };

  services.displayManager.sddm.wayland.enable = true;

  # Configure keymap in X11
  services.xserver = {
    enable = false;
    videoDrivers = ["nvidia"]; # enables nvidia drivers in xorg and wayland
    xkb.layout = "us";
    xkb.variant = "intl";
  };

  # Automounting usb
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    #Extra config if needed
    # https://wiki.nixos.org/wiki/PipeWire#Bluetooth_Configuration
    # https://wiki.archlinux.org/title/bluetooth_headset#Disable_PipeWire_HSP/HFP_profile
  };

  #
  # Enabling steam & other gaming goodness
  #
  #

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.Thieu = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  #Docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    home-manager
    gedit

    neofetch
    ncdu
    vim
    wget
    git
    htop

    egl-wayland
  ];

  # Thunar
  programs.thunar.enable = true;

  # Desktop portals which let windows interact?
  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg.desktop-portal-gtk ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
