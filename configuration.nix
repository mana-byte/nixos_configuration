# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./cachix.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # BLACKLIST NVIDIA TO POWEROFF GPU
  specialisation.disablegpu.configuration = {
    boot.blacklistedKernelModules = [
	    "nvidia"
	    "nvidia_drm"
	    "nvidia_modeset"
	    "nvidia_uvm"
	    "nouveau"
	    # These are a bug fix for linux kernel 6.12.29 that keeps making my computer freeze // Remove when 6.12.30
	    # "typec_ucsi"
	    # "ucsi_acpi"
    ];
    boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    
  };
  # BLACKLIST NVIDIA TO POWEROFF GPU

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  boot.kernelParams = [ 
    "amd_pstate=active"      # Better power management
    "amdgpu.sg_display=0"    # Address graphics stability
    "amdgpu.runpm=0"         # Disable run-time power management
    "acpi_osi=Linux"         # ACPI compatibility
    "acpi_enforce_resources=lax"
  ];
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";
  # services.automatic-timezoned.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_NZ.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_NZ.UTF-8";
    LC_IDENTIFICATION = "en_NZ.UTF-8";
    LC_MEASUREMENT = "en_NZ.UTF-8";
    LC_MONETARY = "en_NZ.UTF-8";
    LC_NAME = "en_NZ.UTF-8";
    LC_NUMERIC = "en_NZ.UTF-8";
    LC_PAPER = "en_NZ.UTF-8";
    LC_TELEPHONE = "en_NZ.UTF-8";
    LC_TIME = "en_NZ.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

 # unstable 
  services.logind.settings.Login = {
     HandleLidSwitchDocked = "ignore";
     HandleLidSwitch = "lock";
     # settings.Login = "IdleAction=ignore";
  };

	#  services.logind = {
	#  	lidSwitchDocked = "ignore";
	# lidSwitch = "lock";
	# extraConfig = "IdleAction=ignore";
	#  };


  # Configure console keymap
  console.keyMap = "fr";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mana = {
    isNormalUser = true;
    description = "Mana";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # linux firmware
    linux-firmware
    # home manager
    home-manager
    # cachix to avoid compiling everything
    cachix
    # list of open files
    lsof
    # basic editor
    vim
    # d bus service
    xdg-desktop-portal
    # usb automount not movable to home manager
    udiskie
    usbutils
    udisks

    #power management
    lm_sensors
    brightnessctl

    ## APPS essential for system functionalities at base

    # terminal emulator
    kitty

    # hyprland ecosystem config in home manager
    hyprpolkitagent
    hyprshot
    hyprlock
    hypridle
    hyprcursor
    hyprsunset
    waybar

    # disk management
    gparted
  ];

  # gdm display manager
  # services.xserver.displayManager.gdm.enable = true;
  # ly display manager
  services.xserver.enable = true;
services.displayManager.ly = {
    enable = true;
    package = pkgs.ly; # TUI -- zig -- https://codeberg.org/AnErrupTion/ly
    # x11Support = true;
    settings = {
      # allow_empty_password = false; # dangerous?
      animation = "colormix"; # "doom", "matrix", "colormix"
      animation_timeout_sec = 600; # 10 minutes
      auth_fails = 3; # special animation looks broken?
      bg = "0x02000000";
      bigclock = "en"; # enlarges the clock -- may not work with some fonts?
      # blank_box = false; # transparent
      border_fg = "0x01FFFFFF";
      box_title = "null"; # text above the box
      clear_password = true;
      clock = "%B, %A %d @ %H:%M:%S";
      colormix_col1 = "0x08090A08";
      colormix_col2 = "0x08FFFFFF";
      colormix_col3 = "0x0800CC00";
      default_input = "password";
      error_bg = "0x02000000";
      error_fg = "0x01FF0000";
      fg = "0x01FFFFFF";
      hide_borders = false;
      hide_version_string = true; # doesnt work?
      hide_key_hints = false;
      initial_info_text = "null"; # hostname
      # input_len = 69;
      lang = "en";
      load = true;
      margin_box_h = 5;
      margin_box_v = 5;
      min_refresh_delta = 1000; # milliseconds -- default=5
      # numlock = true;
      save = true;
      text_in_center = false; # ugly
      # tty = 4; # broken? -- could help with UWSM sessions
      vi_default_mode = "insert";
      vi_mode = true;
      # ...
    };
  };
  # usb auto mounting
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.dbus.enable = true;
  security.polkit.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  programs.kdeconnect = {
     enable = true;
     package = pkgs.kdePackages.kdeconnect-kde;
  };


  # pipewire for sound
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };
  hardware.pulseaudio.enable = false;

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
  ];
  # tlp for battery management
  services.tlp = {
    enable = true;
    settings = {
      # AC settings
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      # Battery settings
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  # ASUSD Configuration - Enhanced
  services.asusd = {
    enable = true;
    enableUserService = false;
    package = pkgs.asusctl;
  };

  # Make sure asusd starts after basic system services
  systemd.services.asusd = {
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
  };

  # Ensure the service is properly enabled
  systemd.services.asusd.enable = true;
  # for deactivating the gpu when not needed 
  # There is an option at the top in kernel params to set initial mode of gpu
  services.supergfxd.enable = false;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
  };


  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  programs.hyprland.enable = true;
  # programs.hyprland.withUWSM  = true;
  # Configure OpenGL properly
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # extraPackages = with pkgs; [
    # 	amdvlk
    # ];
  };

  # Basic display setup
  services.xserver.videoDrivers = ["amdgpu" "nvidia"]; # add nvidia
  boot.initrd.kernelModules = ["amdgpu"];

  # Configure NVIDIA with safe options
  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:65:0:0";
      nvidiaBusId = "PCI:64:0:0";
    };
    nvidiaSettings = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
  };

  # DISABLE AND ENABLE TAILSCALE
    # services.tailscale = {
    #   enable = true;
    #   useRoutingFeatures = "both"; # Enables subnet routing and exit nodes if needed
    # };
  # KDE CONNECT PERMISSIONS
  services.avahi = {
     enable = true;
     nssmdns4 = true;
     openFirewall = true;
  };

  # nix.gc = {
  #   automatic = true;
  #   dates = "monthly"; # runs on the 1st of every month by default
  #   options = "--delete-older-than 30d";
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # List services that you want to enable:

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
