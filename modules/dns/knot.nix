{ config, pkgs, lib, ... }:
{
  sops.secrets.knot_tsig = { };
  sops.secrets.knot_tsig.owner = "knot";
  
  services.knot = {
    enable = true;
    keyFiles = [
      config.sops.secrets.knot_tsig.path
    ];
    
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

      acl:
        - id: update-acme
          key: update-acme
          action: update
          
      zone:
        - domain: pek.mk
          file: "${./pek.mk.zone}"
          acl: update-acme
        - domain: heph.me
          acl: update-acme
          file: "${./heph.me.zone}"
        - domain: oho.pele
          file: "${./pele.zone}"
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
