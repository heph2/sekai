{ self
, nixpkgs
, sops-nix
, inputs
, nix
, nur
, blog-flake
, ...
}:
let
  nixosSystem = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;
  # make flake inputs accessiable in NixOS
  defaultModules = [
    { _module.args.inputs = inputs; }
    {
      imports = [
        ({pkgs, ...}: {
          nix.nixPath = [
            "nixpkgs=${pkgs.path}"
            "nur=${nur}"
          ];
          nix.package = nixpkgs.lib.mkForce nix.packages.x86_64-linux.nix;
          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
          documentation.info.enable = false;          
        })
        ../modules/base.nix
        sops-nix.nixosModules.sops
        blog-flake.defaultPackage.x86_64-linux.out
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

