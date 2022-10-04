{ config, lib, pkgs, ... }:
{
  services.nomad = {
    enable = true;
    settings = {
      server = {
        enabled = true;
        bootstrap_expect = 1;
      };
    };
  };
}
