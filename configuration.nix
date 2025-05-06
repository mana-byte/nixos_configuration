# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

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

  # Configure console keymap
  console.keyMap = "fr";


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mana = {
    isNormalUser = true;
    description = "Mana";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # home manager
    home-manager
    vim

  # hyprland apps
    dunst
    rofi-wayland
    networkmanagerapplet
    pipewire
    waybar
    kitty
    xdg-desktop-portal

    # hyprland ecosystem
    hyprpaper
    hyprpolkitagent
    hyprshot
    hyprlock
    hypridle

  #power management
    tlp
    lm_sensors

  # desktop
    firefox
    nautilus
    clipman

  ];

  fonts.packages = with pkgs; [
    font-awesome
  ];

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT1 = 70; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT1 = 80; # 80 and above it stops charging
    };
  };
  programs.hyprland = {
	enable = true;
 };

  environment.sessionVariables = {
  	WLR_NO_HARDWARE_CURSOR = "1";
	NIXOS_OZONE_WL = "1";

	# this needs to be changed if not the right card
	AQ_DRM_DEVICES="/dev/dri/card1";
  };
  hardware.graphics = {
  	enable =true;
  };


  boot.initrd.kernelModules = [ "amdgpu" ];
	#  services.xserver.videoDrivers = [ "nvidia" ];
	#  hardware.nvidia = {
	#  	modesetting.enable = true;
	# open = true;
	#  	prime = {
	#   offload = {
	#     enable = true;
	#     enableOffloadCmd = true;
	#   };
	#   amdgpuBusId = "PCI:65:0:0";
	#   nvidiaBusId = "PCI:64:0:0";
	# };
	# nvidiaSettings = true;
	#   };

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
