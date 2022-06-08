{ config, pkgs, lib, nur, ... }:
{
  # imports =
  #   [
  #     nur.repos.heph2.modules.pounce
  #   ];

  services.pounce = {
    enable = true;
    hostAddress = "0.0.0.0"; # VPN IP
    hostPort = 6697;
    joinChannels = [ "#gemini-it" ];
    ircHost = "irc.libera.chat";
    ircUser = "tako";
    ircNick = "tako";
    sslCa = config.sops.secrets."pounce/CApem".path;
    sslKey = config.sops.secrets."pounce/key".path;
    sslCert = config.sops.secrets."pounce/cert".path;
    certFP = config.sops.secrets."pounce/certFP".path;
  };
  
  sops.secrets."pounce/CApem" = {
    owner = "pounce";
    mode = "0644";
  };
  sops.secrets."pounce/key" = {
    owner = "pounce";
    mode = "0644";
  };
  sops.secrets."pounce/cert" = {
    owner = "pounce";
    mode = "0644";
  };
  sops.secrets."pounce/certFP" = {
    owner = "pounce";
    mode = "0644";
  };
}
