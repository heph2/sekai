{ config, pkgs, lib, ... }:
{
  imports = [
    #    ./modules/pounce.nix
    #    ./modules/wg.nix
    <nixpkgs/nixos/modules/virtualisation/openstack-config.nix>
    ./modules/blog.nix
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };
  
  system.stateVersion = "21.11";
}
