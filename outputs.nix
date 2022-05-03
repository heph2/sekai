{ self
, nixpkgs
, flake-utils
, terranix
, module-openstack
, sops-nix
, ...
} @ inputs:
(flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
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

      # conf = nixpkgs.lib.nixosSystem {
      #   inherit system;
      #   modules = [
      #     ./config.nix
      #     sops-nix.nixosModules.sops
      #   ];
      # };
      
      # nix develop
      devShell = pkgs.mkShell {
        buildInputs =
          [ terraform terranix.defaultPackage.${system} ];
      };
    })) // {
      # nixosConfigurations = import ./config.nix (inputs // {
      #   inherit inputs;
      # });
    }

