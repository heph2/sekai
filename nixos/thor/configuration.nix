{ config, lib, pkgs, ... }:
{  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];    
  };

  system.stateVersion = "21.11";
}
