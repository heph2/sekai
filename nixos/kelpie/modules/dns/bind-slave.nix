{ config, pkgs, lib, nur, ... }:
{
  disabledModules = [
    "services/networking/bind.nix"
  ];

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
	  zones."heph.me" = {
		  name = "heph.me";
      file = "/etc/bind/zones/heph.me";
		  master = false; # slave server
      masters = [ "90.147.188.89" ];
	  };
    zones."pele" = {
      name = "pele";
      file = "/etc/bind/zones/pele";
      master = false;
      masters = [ "90.147.188.89" ];
    };
	  zones."pek.mk" = {
		  name = "pek.mk";
      file = "/etc/bind/zones/pek.mk";
		  master = false; # slave server
      masters = [ "90.147.188.89" ];
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
