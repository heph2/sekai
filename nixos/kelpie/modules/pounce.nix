{ config, pkgs, ... }:
{
  sops.secrets."pounce/CApem" = {};
  sops.secrets."pounce/key" = {};
  sops.secrets."pounce/cert" = {};
  sops.secrets."pounce/certFP" = {};
  services.pounce = {
    enable = true;
    hostAddress = ""; # VPN IP
    hostPort = 6697;
    joinChannels = [ "#gemini.it" ];
    ircHost = "irc.libera.chat";
    ircUser = "tako";
    ircNick = "tako";
    sslCa = sops.secrets."pounce/CApem".path;
    sslKey = sops.secrets."pounce/key".path;
    sslCert = sops.secrets."pounce/cert".path;
    certFP = sops.secrets."pounce/certFP".path;
  };
}
