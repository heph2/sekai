{ config, pkgs, lib, ... }:
{
  services = {
    restic = {
      server = {
        enable = true;
        prometheus = true;
        extraFlags = [ "--no-auth" ];
        listenAddress = "172.18.0.5:8000";
      };
    };

    nginx = {
      enable = true;
      virtualHosts."backup.pele" = {
        locations."/" = {
          proxyPass = "http://172.18.0.5:8000";
          proxyWebsockets = true;
        };
      };
    };
  };
}
