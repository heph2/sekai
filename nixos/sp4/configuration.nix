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
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
#      wireplumber.enable = true;

#      media-session.config.bluez-monitor = {
#	 properties = { bluez5.codecs = [ "ldac" "aptx_hd" ]; };
#	 rules = [
#	   {
#	     matches = [ { "device.name" = "~bluez_card.*"; } ];
#	     actions = {
#               "update-props" = {
#                 "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
#                 # mSBC is not expected to work on all headset + adapter combinations.
#                 "bluez5.msbc-support" = true;
#                 # SBC-XQ is not expected to work on all headset + adapter combinations.
#                 "bluez5.sbc-xq-support" = true;
#               };
#	     };
#	   }
#	   {
#	     matches = [
#                # Matches all sources
#                { "node.name" = "~bluez_input.*"; }
#                # Matches all outputs
#                { "node.name" = "~bluez_output.*"; }
#             ];
#             actions = {
#               "node.pause-on-idle" = false;
#             };
#	   }
#	 ];
#      };
    };
    openssh = {
      enable = true;
      permitRootLogin = "prohibit-password";
    };

    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };
  };

  # Enable sound
  sound.enable = true;
  hardware = {
    opengl = {
	enable = true;
	extraPackages = with pkgs; [
	   intel-media-driver
	   vaapiIntel
	   vaapiVdpau
	   libvdpau-va-gl
	];
	driSupport32Bit = true;
    };
    pulseaudio.enable = false;
    sane.enable = true;
    ## Bluetooth support
  };
  security.rtkit.enable = true;
  programs.light.enable = true;
  programs.gnupg.agent.enable = true;
  programs.steam = {
	enable = true;
	remotePlay.openFirewall = true;
	dedicatedServer.openFirewall = true;
  };

  programs.ssh.startAgent = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    heph = {
      isNormalUser = true;
      description = "heph";
      extraGroups = [ "networkmanager" "wheel" "video" "input" ];
    };
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCmIz2Selg5eJ77lvpJHgDJiRIOZbucMjDK5zrhTEWK heph@fenrir"
    ];
  };
  
  nix = {
    buildMachines = [
      {
        hostName = "builder";
        system = "x86_64-linux";
        maxJobs = 8;
        speedFactor = 2;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
      {
        hostName = "odin";
        system = "aarch64-linux";
        maxJobs = 1;
        speedFactor = 2;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
    ];
    distributedBuilds = true;
    package = pkgs.nixFlakes;
    extraOptions = ''
      builders-use-substitutes = true
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
  };

  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  nixpkgs.overlays = [
    (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; } )
  ];
  
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  fonts.fonts = with pkgs; [
    font-awesome
  ];
  
  environment.systemPackages = with pkgs; [
    # Editor
    neovim emacs

    # Terminal emulator & Shell
    alacritty foot zsh

    # Window Manager & Sway things
    sway wayland waybar nwg-launchers swaybg swaylock-effects
    glib dracula-theme gnome3.adwaita-icon-theme swayidle
    swaylock swayidle bemenu mako i3status rofi-wayland rofi-power-menu
    rofi-pass

    # Languages
    cargo rustc gcc
    (python3.withPackages (p: with p; [
    	pip
	virtualenv
    ]))

    # Gestures
    libinput-gestures wmctrl xdotool fusuma
    
    # Screenshot & Clipboard
    grim slurp wl-clipboard

    # Browser
    firefox-wayland telescope

    # Notes
    xournalpp rnote

    # Chat
    tdesktop element-desktop-wayland

    # CLI Stuff
    git imv zathura ytfzf lm_sensors pass pinentry-curses mpv sshfs
    texlive.combined.scheme-basic simple-scan evince

    # Audio stuff
    pulseaudio pamixer wob

    # Nix stuff
    nix-direnv direnv home-manager

    # Games
    steam-run
  ];

  ## Enable fusuma for touchpad gestures
  #systemd.services."fusuma" = {
  #  environment = {
  #    DISPLAY = ":0";
  #  };
  #  enable = true;
  #  wantedBy = [ "enable.target" ];
  #  after = [ "graphical-session.target" ];
  #  serviceConfig.User = "heph"; 
  #  serviceConfig.Restart = "on-failure";
  #  serviceConfig.ExecStart = "${pkgs.fusuma}/bin/fusuma -c /home/heph/.config/fusuma/config.yml";
  #};
  
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
  };

  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty? ]] && sudo /run/current-system/sw/bin/lock this
    [[ "$(tty)" == /dev/tty1 ]] && sway
  '';
  system.stateVersion = "22.05";
}
