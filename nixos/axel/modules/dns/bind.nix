{ config, pkgs, lib, nur, ... }:
let
  acmeChallenge = domain:
    pkgs.writeText "_acme-challenge.${domain}.zone" ''
$ORIGIN .
$TTL 300        ; 5 minutes
_acme-challenge.${domain}. IN SOA ns1.heph.me. catch@mrkeebs.eu. (
                                2020050806 ; serial
                                10800      ; refresh (3 hours)
                                3600       ; retry (1 hour)
                                604800     ; expire (1 week)
                                86400      ; minimum (1 day)
                                )
                        NS      ns1.heph.me.
$TTL 60         ; 1 minute
    '';  
in
{
  disabledModules = [
    "services/networking/bind.nix"
  ];
  
  environment.etc."bind/zones/heph.me" = {
    mode = "0644";
    source = ./heph.me.zone;
    user = "named";
    group = "named";
  };

  environment.etc."bind/zones/pek.mk" = {
    mode = "0644";
    source = ./pek.mk.zone;
    user = "named";
    group = "named";
  };

  environment.etc."bind/zones/pele" = {
    mode = "0644";
    source = ./pele.zone;
    user = "named";
    group = "named";
  };

  environment.etc."bind/zones/_acme-challenge.chat.pek.mk" = {
    mode = "0644";
    source = "${acmeChallenge "chat.pek.mk"}";
    user = "named";
    group = "named";
  };

  environment.etc."bind/zones/_acme-challenge.voice.pek.mk" = {
    mode = "0644";
    source = "${acmeChallenge "voice.pek.mk"}";
    user = "named";
    group = "named";
  };

  environment.etc."bind/zones/_acme-challenge.conference.pek.mk" = {
    mode = "0644";
    source = "${acmeChallenge "conference.pek.mk"}";
    user = "named";
    group = "named";
  };
  
  environment.etc."bind/zones/_acme-challenge.pek.mk" = {
    mode = "0644";
    source = "${acmeChallenge "pek.mk"}";
    user = "named";
    group = "named";
  };
  
  environment.etc."bind/zones/_acme-challenge.heph.me" = {
    mode = "0644";
    source = "${acmeChallenge "heph.me"}";
    user = "named";
    group = "named";
  };
  
  sops.secrets.knot_tsig = {
    owner = "named";
    mode = "0644";
  };

	services.bind = {
	  enable = true;
	  listenOn = [ "any" ];
    extraOptions = ''
       recursion yes;
       allow-query-cache { cachenetworks; };
    '';
    keyFiles = [ config.sops.secrets.knot_tsig.path ];
    zones."pele" = {
      name = "pele";
      file = "/etc/bind/zones/pele";
      master = true;
      slaves = [ "127.0.0.1" "90.147.189.232" ];
    };
	  zones."heph.me" = {
		  name = "heph.me";
      file = "/etc/bind/zones/heph.me";
		  master = true;
      slaves = [ "127.0.0.1" "90.147.189.232" ];
      extraConfig = ''
         update-policy {
             grant ddns-key zonesub ANY;
         };
      '';
	  };
	  zones."pek.mk" = {
		  name = "pek.mk";
      file = "/etc/bind/zones/pek.mk";
		  master = true;
      slaves = [ "127.0.0.1" "90.147.189.232" ];
      extraConfig = ''
         update-policy {
             grant ddns-key zonesub ANY;
         };
      '';
	  };
    zones."_acme-challenge.chat.pek.mk" = {
      name = "_acme-challenge.chat.pek.mk";
      file = "/etc/bind/zones/_acme-challenge.chat.pek.mk";
      master = true;
      slaves = [ "127.0.0.1" "90.147.189.232" ];
      extraConfig = ''
         update-policy {
             grant ddns-key zonesub ANY;
         };
      '';
    };
    zones."_acme-challenge.conference.pek.mk" = {
      name = "_acme-challenge.conference.pek.mk";
      file = "/etc/bind/zones/_acme-challenge.conference.pek.mk";
      master = true;
      slaves = [ "127.0.0.1" "90.147.189.232" ];
      extraConfig = ''
         update-policy {
             grant ddns-key zonesub ANY;
         };
      '';
    };    
    zones."_acme-challenge.voice.pek.mk" = {
      name = "_acme-challenge.voice.pek.mk";
      file = "/etc/bind/zones/_acme-challenge.voice.pek.mk";
      master = true;
      slaves = [ "127.0.0.1" "90.147.189.232" ];
      extraConfig = ''
         update-policy {
             grant ddns-key zonesub ANY;
         };
      '';
    };    
    zones."_acme-challenge.pek.mk" = {
      name = "_acme-challenge.pek.mk";
      file = "/etc/bind/zones/_acme-challenge.pek.mk";
      master = true;
      slaves = [ "127.0.0.1" "90.147.189.232" ];
      extraConfig = ''
         update-policy {
             grant ddns-key zonesub ANY;
         };
      '';
    };        
    zones."_acme-challenge.chat.heph.me" = {
      name = "_acme-challenge.chat.heph.me";
      file = "/etc/bind/zones/_acme-challenge.chat.heph.me";
      master = true;
      slaves = [ "127.0.0.1" "90.147.189.232" ];
      extraConfig = ''
         update-policy {
             grant ddns-key zonesub ANY;
         };
      '';
    };
    zones."_acme-challenge.heph.me" = {
      name = "_acme-challenge.heph.me";
      file = "/etc/bind/zones/_acme-challenge.heph.me";
      master = true;
      slaves = [ "127.0.0.1" "90.147.189.232" ];
      extraConfig = ''
         update-policy {
             grant ddns-key zonesub ANY;
         };
      '';
    };    
    extraConfig = ''
statistics-channels {
inet 127.0.0.1 port 8053 allow { 127.0.0.1; };
};
    '';
  };

	networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
