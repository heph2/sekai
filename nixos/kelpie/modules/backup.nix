{ config, pkgs, lib, ... }:
{
  services = {
    restic = {
      backups."kelpie" = {
        repository = "rest:http://backup.pele/kelpie";
      };
    };
  };
}
