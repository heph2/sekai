{ config, pkgs, lib, ... }:
{
  services.prosody = {
    enable = true;
    admins = [ "admin@chat.pek.mk" ];
    virtualHosts."chat.pek.mk" = {
      enabled = true;
      domain = "chat.pek.mk";
    };
    muc = [ {
      domain = "conference.pek.mk";
    }];
    uploadHttp = {
      domain = "http://upload.pek.mk";
    };

    ssl = {
      key = "/var/lib/acme/chat.pek.mk/key.pem";
      cert = "/var/lib/acme/chat.pek.mk/fullchain.pem";
    };
    
    modules.motd = true;
    package = pkgs.prosody.override {
      withCommunityModules = [ "http_upload" ];
    };
  };

  security.acme = {
    certs."chat.pek.mk" = {
      postRun = "systemctl restart prosody.service";
      group = "prosody";
      dnsProvider = "rfc2136";
      credentialsFile = config.sops.secrets.lego-knot-credentials.path;
    };
  };

  networking.firewall.allowedTCPPorts = [
    5222 # xmpp-client
    5269 # xmpp-server
    5280 # xmpp-bosh
    5443 # https
    1883 # mqtt
    # which port for proxy64?
    #6555 # xmpp-proxy65
  ];  

  # format:
  # RFC2136_NAMESERVER=ns1.heph.me
  # RFC2136_TSIG_ALGORITHM=hmac-sha256.
  # RFC2136_TSIG_KEY=ddns-key
  # RFC2136_TSIG_SECRET="00000000000000000000000000000000000000000000"
}
