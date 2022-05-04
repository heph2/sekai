{ self
, nixpkgs
, flake-utils
, terranix
, module-openstack
, nur
, sops-nix
, deploy-rs
, ...
} @ inputs:
(flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages."${system}";
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
        buildInputs = [
          terraform terranix.defaultPackage.${system}
          deploy-rs.packages.${system}.deploy-rs
        ];
      };
    })) // {
      nixosConfigurations = import ./nixos/configuration.nix (inputs // {
        inherit inputs;
      });
      deploy = import ./nixos/deploy.nix (inputs // {
        inherit inputs;
      });
      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    }

