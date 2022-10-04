{ config, lib, pkgs, ... }:
{
  imports = [
    ./nomad.nix
  ];
  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];    
  };

  system.stateVersion = "21.11";
}
