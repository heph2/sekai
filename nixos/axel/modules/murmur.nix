{ config, lib, pkg, ... }:
{
  
  services.murmur = {
    enable = true;
    welcometext = "Welcome to Pek's Mumble Server!";
    password = "$MURMURD_PASSWORD";
    environmentFile = config.sops.secrets.mumble_pass.path;
    sendVersion = false;
    sslKey = "/var/lib/acme/voice.pek.mk/key.pem";
    sslCert = "/var/lib/acme/voice.pek.mk/fullchain.pem";
    hostName = "192.168.2.20";
  };

  security.acme = {
    certs."voice.pek.mk" = {
      postRun = "systemctl restart murmur.service";
      group = "murmur";
      dnsProvider = "rfc2136";
      credentialsFile = config.sops.secrets.lego-knot-credentials.path;
    };
  };
  
  networking.firewall = {
    allowedTCPPorts = [ 64738 ];
    allowedUDPPorts = [ 64738 ];
  };
}
