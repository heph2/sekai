{ config, pkgs, lib, ... }:
{
	services.bind = {
	   enable = true;
	   listenOn = [ "any" ];
	   zones."heph.me" = {
		name = "heph";
		file = ./heph.me.zone;
		master = true;
	   };
	};

	networking.firewall = {
          allowedTCPPorts = [ 53 ];
          allowedUDPPorts = [ 53 ];
        };
}
