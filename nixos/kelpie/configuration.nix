{ config, pkgs, lib, ... }:
{
  imports = [
    ./modules/pounce.nix
    ./modules/wg.nix
  ];

  system.stateVersion = "21.11";
}
