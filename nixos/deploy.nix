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
    axel = mkNode "axel" "90.147.188.89" true; #GARR
    kelpie = mkNode "kelpie" "90.147.189.232" true; #GARR
    casper = mkNode "casper" "129.152.7.231" true; #ORACLE AMD
    thor = mkNode "thor" "129.152.13.29" true; #ORACLE AMD
    hod = mkNodeARM "hod" "129.152.2.37" true; #ORACLE ARM
    odin = mkNodeARM "odin" "129.152.0.135" true; #ORACLE ARM

    sp4 = mkNode "sp4" "192.168.1.248" true; #SURFACE PRO
  };
}
