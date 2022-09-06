{ config, pkgs, ... }: {
  services = {
    grafana = {
      enable = true;
      domain = "grafana.pele";
      port = 2342;
      addr = "172.18.0.1";
    };

    # nginx reverse proxy
    nginx = {
      enable = true;
      virtualHosts.${config.services.grafana.domain} = {
        locations."/" = {
          proxyPass = "http://172.18.0.1:${toString config.services.grafana.port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
