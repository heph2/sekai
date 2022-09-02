{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hw.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "net.ifnames=0" ];

  boot.zfs.devNodes = "/dev";

  networking.hostId = "deadbeef";
  networking.hostName = "alcaloid"; # Define your hostname.

#  networking.useDHCP = false;  # deprecated flag, set to false until removed

  # Select internationalisation properties.
   console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
   };
   i18n = {
     defaultLocale = "en_US.UTF-8";
   };

  # Set your time zone.
   time.timeZone = "Europe/Rome";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCmIz2Selg5eJ77lvpJHgDJiRIOZbucMjDK5zrhTEWK heph@fenrir"
  ];

  environment.systemPackages = with pkgs; [
    neovim
    screen
    git
    deploy-rs
    mg cachix
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowPing = true;

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Test DynDNS
  security.acme = {
    acceptTerms = true;
    defaults.email = "catch@mrkeebs.eu";
    certs."dns.heph.me" = {
#      group = "nginx";
      dnsProvider = "rfc2136";
      credentialsFile = "/root/cred.sh";
    };
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}  
