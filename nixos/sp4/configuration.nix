{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./wm.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];      
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  # Networking
  networking = {
    hostName = "nixos"; # Define your hostname.
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.utf8";
    LC_IDENTIFICATION = "it_IT.utf8";
    LC_MEASUREMENT = "it_IT.utf8";
    LC_MONETARY = "it_IT.utf8";
    LC_NAME = "it_IT.utf8";
    LC_NUMERIC = "it_IT.utf8";
    LC_PAPER = "it_IT.utf8";
    LC_TELEPHONE = "it_IT.utf8";
    LC_TIME = "it_IT.utf8";
  };


  # Enable CUPS to print documents.
  services = {
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
    openssh = {
      enable = true;
      permitRootLogin = "prohibit-password";
    };
  };

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  programs.light.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    heph = {
      isNormalUser = true;
      description = "heph";
      extraGroups = [ "networkmanager" "wheel" "video" ];
      packages = with pkgs; [
        firefox
      ];      
    };
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCmIz2Selg5eJ77lvpJHgDJiRIOZbucMjDK5zrhTEWK heph@fenrir"
    ];
  };
  
  nix = {
    buildMachines = [ {
      hostName = "builder";
      system = "x86_64-linux";
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    }];
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
  
  environment.systemPackages = with pkgs; [
    # Editor
    neovim emacs

    # Terminal emulator
    alacritty

    # Window Manager & Sway things
    sway dbus-sway-environment configure-gtk wayland
    glib dracula-theme gnome3.adwaita-icon-theme
    swaylock swayidle bemenu mako i3status

    # Screenshot & Clipboard
    grim slurp wl-clipboard     
  ];

  system.stateVersion = "22.05";
}
