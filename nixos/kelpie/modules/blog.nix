{ config, pkgs, lib, ... }:
{
  services = {
    nginx = {
      enable = true;
      virtualHosts."www.pek.mk" = {
        enableACME = true;
        forceSSL = true;
        root = "/var/www/blog";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      "www.pek.mk".email = "catch@mrkeebs.eu";
    };
  };
}
