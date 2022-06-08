{pkgs, lib, config, ...}:
{
  services.nsd = {
    enable = true;
    verbosity = 3;
    interfaces = [ "192.168.2.20" ];
    zones."pek.mk" = {
      dnssec = false;
      data = ''
@ 3600 IN SOA ns1.pek.mk. ns2.pek.mk. 1654111767 7200 3600 86400 3600

$TTL 600

; NS records
@ 300 IN NS ns1.pek.mk.
@ 300 IN NS ns2.pek.mk.

www   	    300   IN	A	90.147.189.232
@     	    300   IN	A	90.147.189.232
chat  	    300   IN 	A	90.147.189.89
conference  300   IN	A	90.147.189.89
upload	    300	  IN	A 	90.147.189.89
voice	    300	  IN	A	129.152.11.177
      '';      
    }; # pek.mk
    zones."heph.me" = {
      dnssec = false;
      data = ''
@ 3600 IN SOA ns1.heph.me. ns2.heph.me. 2022052900 7200 3600 86400 3600

$TTL 600

@ 300 IN NS ns1.heph.me.
@ 300 IN NS ns2.heph.me.

www   	    300	IN	A	90.147.189.232
      '';
    }; # heph.me
  };

  networking.extraHosts = "90.147.189.232 ns1.pek.mk ns2.pek.mk ns1.heph.me ns2.heph.me";
}
