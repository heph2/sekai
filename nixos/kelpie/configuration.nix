{ config, pkgs, lib, ... }:
{
  imports = [
    ./modules/pounce.nix
    ./modules/dns/bind-slave.nix
    ./modules/wireguard.nix
    ../../modules/base.nix
    ./modules/monitoring.nix
    ./modules/backup.nix
#    ./modules/mail.nix
#    ./modules/blog.nix
  ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.secrets.wireguard_priv = { };
  sops.secrets.knot_tsig = { };
  sops.secrets."pounce/CApem" = { };
  sops.secrets."pounce/key" = { };
  sops.secrets."pounce/cert" = { };
  sops.secrets."pounce/certFP" = { };

  systemd.services.pounce = {
    serviceConfig.SupplementaryGroups = [ config.users.groups.keys.name ];
  };

  systemd.services.bind = {
    serviceConfig.SupplementaryGroups = [ config.users.groups.keys.name ];
  };
  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 6697 ];
    allowedUDPPorts = [ 51820 ];
  };

  environment.systemPackages = with pkgs; [
    dnsutils tcpdump
  ];
  time.timeZone = "Europe/Rome";
  system.stateVersion = "21.11";
}
