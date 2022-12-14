{ config, pkgs, lib, ... }:
{
  services = {
    restic = {
      backups."kelpie" = {
        initialize = true;
        repository = "rest:http://backup.pele/kelpie";
        passwordFile = "/root/pssw";
        paths = [
          "/root"
          "/etc/bind"
          "/var/lib/pounce"
          "/var/lib/acme"
        ];
        timerConfig = {
          OnCalendar = "daily";
        };
      };
    };
  };
}
