{ self
, nixpkgs
, sops-nix
, inputs
, nix
, ...
}:
let
  nixosSystem = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;
  # make flake inputs accessiable in NixOS
  defaultModules = [
    {_module.args.inputs = inputs; }
    {
      imports = [
        ({pkgs, ...}: {
          nix.nixPath = [
            "nixpkgs=${pkgs.path}"
            "nur=${nur}"
          ];
          documentation.info.enable = false;          
        })
        sops-nix.nixosModules.sops
      ];
    }
  ];
in
{
  kelpie = nixosSystem {
    system = "x86_64-linux";
    modules =
      defaultModules
      ++ [
        ./kelpie/configuration.nix
      ];
  };
}

