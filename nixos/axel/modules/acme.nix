{ config, lib, pkgs, ... }:
{
  sops.secrets.lego-knot-credentials = { };
  sops.secrets.lego-knot-credentials.owner = "acme";
  security.acme = {
      # format:
      # RFC2136_NAMESERVER=ns1.pek.mk
      # RFC2136_TSIG_ALGORITHM=hmac-sha256.
      # RFC2136_TSIG_KEY=acme
      # RFC2136_TSIG_SECRET="00000000000000000000000000000000000000000000"
    defaults = {
      dnsProvider = "rfc2136";
      dnsResolver = "ns1.pek.mk";
      #      dnsResolver = "127.0.0.1";
      postRun = "systemctl reload prosody.service";
      group = "prosody";
      credentialsFile = config.sops.secrets.lego-knot-credentials.path;
    };
    certs."pek.mk" = {
      domain = "pek.mk";
    };
  };
}
