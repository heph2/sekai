{ self
, deploy-rs
, ...
}:
let
  mkNode = server: ip: fast: {
    hostname = "${ip}";
    fastConnection = fast;
    profiles.system.path =
      deploy-rs.lib.x86_64-linux.activate.nixos
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
    kelpie = mkNode "kelpie" "90.147.189.232" true;
  };
}
