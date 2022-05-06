{ config, pkgs, lib, blog-flake, ... }:
{
  services = {
    nginx = {
      enable = true;
      virtualHosts."www.pek.mk" = {
        enableACME = true;
        forceSSL = true;
#        root = blog-flake.defaultPackage.x86_64-linux.out;
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
