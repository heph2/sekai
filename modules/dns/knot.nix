{ config, pkgs, lib, ... }:
{
  services.knot = {
    enable = true;
    extraConfig = ''
      server:
        listen: 0.0.0.0@53
        user: knot:knot
        rundir: "/run/knot"
        
      mod-rrl:
        - id: default
          rate-limit: 200
          slip: 2

      policy:
        - id: rsa2k
          algorithm: RSASHA256
          ksk-size: 4096
          zsk-size: 2048

      template:
        - id: default
          semantic-checks: on
          global-module: mod-rrl/default

      log:
        - target: syslog
          any: info

      zone:
        - domain: pek.mk
          file: "${./pek.mk.zone}"
        - domain: heph.me
          file: "${./heph.me.zone}"
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
