{ config, pkgs, lib, ... }:
{
  imports = [
    ./modules/prosody.nix
    ./modules/dns/bind.nix
    ./modules/murmur.nix
    ./modules/restic.nix
    ./modules/backup.nix
  ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.secrets.lego-knot-credentials = { };
  sops.secrets.mumble_pass = { };
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 53 80 5281 5280 5222 5269 8000 ];
      allowedUDPPorts = [ 53 ];
      allowPing = true;
    };
    hostName = "axel";
  };
  time.timeZone = "Europe/Rome";

  environment.systemPackages = with pkgs; [
    dnsutils tcpdump
  ];

  system.stateVersion = "22.11";
}

  
