{ config, pkgs, lib, ... }:
{
  imports = [
#    ./modules/prosody.nix
#    ./modules/acme.nix
    ./modules/dns/bind.nix
  ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 53 80 5281 5280 5222 5269 ];
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

  
