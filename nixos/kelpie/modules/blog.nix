{ config, pkgs, lib, inputs, ... }:
{
  services = {
    nginx = {
      enable = true;
      virtualHosts."www.pek.mk" = {
        enableACME = true;
        forceSSL = true;
        root = "${inputs.blog-flake.defaultPackage.x86_64-linux}";
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
