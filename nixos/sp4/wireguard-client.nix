{ config, pkgs, ... }:
{
  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; 
  };
  # Enable WireGuard
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "172.18.0.6/24" ];
      listenPort = 51820;
      privateKeyFile = "/root/wg-priv";
      #      generatePrivateKeyFile = true;

      peers = [
        {
          # Public key of the server (not a file path).
          publicKey = "sbPzZqYrggqd57x+lxR3vUbp9BYFlkOG9mJu78so+hg=";

          # Forward all the traffic via VPN.
          allowedIPs = [ "172.18.0.0/24" ];
          # Or forward only particular subnets
          #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

          # Set this to the server IP and port.
          endpoint = "90.147.189.232:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
