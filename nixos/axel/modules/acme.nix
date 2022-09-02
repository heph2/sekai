{ config, lib, pkgs, ... }:
{
  sops.secrets.lego-knot-credentials = { };
  sops.secrets.lego-knot-credentials.owner = "acme";
  security.acme = {
    # format:
    # RFC2136_NAMESERVER=ns1.heph.me
    # RFC2136_TSIG_ALGORITHM=hmac-sha256.
    # RFC2136_TSIG_KEY=ddns-key
    # RFC2136_TSIG_SECRET="00000000000000000000000000000000000000000000"
    acceptTerms = true;
    defaults = {
      email = "catch@mrkeebs.eu";
      dnsProvider = "rfc2136";
      dnsResolver = "ns1.heph.me";
      #      postRun = "systemctl reload prosody.service";
      #      group = "prosody";
      credentialsFile = config.sops.secrets.lego-knot-credentials.path;
    };
    certs."dns.heph.me" = {
      #      domain = "pek.mk";
    };
  };
}
