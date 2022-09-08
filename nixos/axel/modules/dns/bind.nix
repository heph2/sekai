{ config, pkgs, lib, nur, ... }:
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
