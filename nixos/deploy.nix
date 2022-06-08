{ self
, deploy-rs
, ...
}:
let
  mkNode = server: ip: fast: {
    hostname = "${ip}";
    fastConnection = false;
    profiles.system.path =
      deploy-rs.lib.x86_64-linux.activate.nixos
        self.nixosConfigurations."${server}";
  };
  mkNodeARM = server: ip: fast: {
    hostname = "${ip}";
    fastConnection = fast;
    profiles.system.path =
      deploy-rs.lib.aarch64-linux.activate.nixos
        self.nixosConfigurations."${server}";
  };  
  hosts = import ./machines/nixos-machines.nix;
in
{
  user = "root";
  sshUser = "root";
  sshOpts = [ "-i" "~/.ssh/sekai_ed" ];
  nodes = {
    #kelpie = mkNode "kelpie" hosts.kelpie.host.ipv4 true;
    #    axel = mkNode "axel" hosts.axel.host.ipv4 true;
    axel = mkNode "axel" "90.147.188.89" true; #GARR
    kelpie = mkNode "kelpie" "90.147.189.232" true; #GARR
    casper = mkNode "casper" "129.152.7.231" true;
    thor = mkNode "thor" "129.152.13.29" true;
    hod = mkNodeARM "hod" "129.152.2.37" true;
    odin = mkNodeARM "odin" "129.152.22.43" true;
  };
}
