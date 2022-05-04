{ config, pkgs, lib, ... }:
{
  imports = [
    #    ./modules/pounce.nix
    #    ./modules/wg.nix
    # <nixpkgs/nixos/modules/virtualisation/openstack-config.nix>
  ];

  
  system.stateVersion = "21.11";
}
