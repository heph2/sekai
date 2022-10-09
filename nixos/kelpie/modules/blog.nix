{ config, pkgs, lib, inputs, ... }:
{
#   services = {
#     nginx = {
#       enable = true;
#       virtualHosts."www.pek.mk" = {
# #        enableACME = true;
#         forceSSL = true;
#         root = "${inputs.blog-flake.defaultPackage.x86_64-linux}";
#       };
#     };
#   };

  security.acme = {
    certs."www.pek.mk" = {
      postRun = "systemctl restart nginx.service";
      group = "nginx";
      dnsProvider = "inwx";
      credentialsFile = config.sops.secrets.lego-inwx-credentials.path;
    };
  };
}
