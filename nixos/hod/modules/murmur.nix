{ config, pkgs, ... }:
{
  services.murmur = {
    enable = true;
    welcometext = "Welcome to my Mumble Server! Enjoy Your stay";
    password = "";
    sslKey = "";
    sslCert = "";
    sslCa = "";
    sendVersion = false;
    registerUrl = "voice.pek.mk";
    ## probably you can set password through env and sops-nix
    ## need to investigate on this
    environmentFile = "";
  };
}
