{ config, pkgs, lib, ... }:
{
  #sops.secrets.wireguard_priv = { };
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking = {
    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ "wg0" ];
    };
    enableIPv6 = false;
    firewall.allowedUDPPorts = [ 51820 ];
    wireguard.interfaces = {
      wg0 = {
        ips = [ "172.18.0.1/24" ];
        listenPort = 51820;

        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 172.18.0.0/24 -o ens3 -j MASQUERADE
        '';

        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 172.18.0.0/24 -o ens3 -j MASQUERADE
        '';
        
        privateKeyFile = config.sops.secrets.wireguard_priv.path;
        peers = [
          {
            publicKey = "v5/a4i1O7qYrk09s66mcDHhK/ZLQQFmLZw9/wj//OAg=";
            allowedIPs = [ "172.18.0.3/32" "192.168.1.0/24" ];
          } # HOME
          {
            publicKey = "Cck0Pf41dZw5jzKuwP4TkfZcrp+iBMPYC+ocQG2H3WQ=";
            allowedIPs = [ "172.18.0.4/32" ];
          } # ANDROID
          {
            publicKey = "O+qIb83zCnhGvxRQQy1lAxx3bn5Y7OU10KjiZPpVDXc=";
            allowedIPs = [ "172.18.0.5/32" ];
          } # AXEL
          {
            publicKey = "vmI4qI2YwA1Qt2XUfKOpEQOdoypHoeF0kZ8r96dmz10=";
            allowedIPs = [ "172.18.0.6/32" ];
          }
        ];
      }; # WG0
    }; # WIREGUARD
  }; # NETWORKING

  environment.systemPackages = with pkgs; [
    wireguard-tools tcpdump
  ];
}
