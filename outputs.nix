{ self
, nixpkgs
, flake-utils
, terranix
, module-openstack
, nur
, sops-nix
, ...
} @ inputs:
(flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    nurPkgs = import nur {
      inherit pkgs;
      nurpkgs = pkgs;
    };
    terraform = pkgs.writers.writeBashBin "terraform" ''
      ${pkgs.terraform}/bin/terraform "$@"
    '';
    terranixConfiguration = terranix.lib.terranixConfiguration {
      inherit system;
      modules = [
        module-openstack.terranixModule
        ./config.nix
      ];
    };
  in
    {
      defaultPackage = terranixConfiguration;      
      # nix develop
      devShell = pkgs.mkShell {
        buildInputs =
          [ terraform terranix.defaultPackage.${system} ];
      };
    })) // {
      nixosConfigurations = import ./nixos/configuration.nix (inputs // {
        inherit inputs;
      });
    }

