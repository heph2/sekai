{ config, pkgs, lib, ... }:
{
  services = {
    restic = {
      backups."axel" = {
        initialize = true;
        repository = "rest:http://backup.pele/axel";
        passwordFile = "/root/pssw";
        paths = [
          "/root"
          "/etc/bind"
          "/var/lib/murmur"
          "/var/lib/acme"
        ];
        timerConfig = {
          OnCalendar = "daily";
        };
      };
    };
  };
}
