{ config, pkgs, lib, ... }:
{
  services.prosody = {
    enable = true;
    admins = [ "admin@chat.pek.mk" ];
    virtualHosts."chat.pek.mk" = {
      enabled = true;
      domain = "pek.mk";
    };
    muc = [ {
      domain = "conference.pek.mk";
    }];
    uploadHttp = {
      domain = "https://upload.pek.mk";
    };

    modules.motd = true;
    extraConfig = ''
      log = "/var/lib/prosody/prosody.log"
      motd_text = [[Welcome! Type /help -a for a list of commands.]]
    '';
    package = pkgs.prosody.override {
      withCommunityModules = [ "http_upload" ];
    };
  };

  security.acme = {
    defaults.email = "work@mrkeebs.eu";
    acceptTerms = true;
  };

  services.nginx.virtualHosts."chat.pek.mk" = {
    addSSL = true;
    enableACME = true;
  };
}