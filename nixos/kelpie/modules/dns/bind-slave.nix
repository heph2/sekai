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
	};

	networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
