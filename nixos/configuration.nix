
{ self
, nixpkgs
, nixpkgs-sp4
, sops-nix
, inputs
, nix
, nur
, blog-flake
, nixos-hardware
, home-manager
, neovim-nightly-overlay
, nixos-mailserver
, ...
}:
let
  nixosSystem = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;
  nixos-sp4 = nixpkgs-sp4.lib.makeOverridable nixpkgs-sp4.lib.nixosSystem;
  overlays = [
	inputs.neovim-nightly-overlay.overlay
  ];
  # make flake inputs accessiable in NixOS
  defaultModules = [
    {
      _module.args.self = self;
      _module.args.inputs = self.inputs;
    }
    {
      imports = [
        ({pkgs, ...}: {
          nix.nixPath = [
            "nixpkgs=${pkgs.path}"
            "nur=${nur}"
          ];
          #nix.package = nixpkgs.lib.mkForce nix.packages.x86_64-linux.nix;
          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
          documentation.info.enable = false;          
        })
        ../modules/base.nix
        ../modules/nur.nix
        ../modules/acme.nix
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
        ../modules/base-openstack.nix
      ] ++ [
        nixos-mailserver.nixosModule
      ] ++ [
        { nixpkgs.overlays = [ nur.overlay ]; }
        ({ pkgs, ... }:
          let
            nur-no-pkgs = import nur {
              nurpkgs = import nixpkgs { system = "x86_64-linux"; };
            };
          in {
            imports = [
              nur-no-pkgs.repos.heph2.modules.pounce
              nur-no-pkgs.repos.heph2.modules.bind
            ];
          })
      ];
  };

  axel = nixosSystem {
    system = "x86_64-linux";
    modules =
      defaultModules
      ++ [
        ./axel/configuration.nix
      ] ++ [
        ../modules/base-openstack.nix
        ../modules/wireguard-client.nix        
      ] ++ [
        { nixpkgs.overlays = [ nur.overlay ]; }
        ({ pkgs, ... }:
          let
            nur-no-pkgs = import nur {
              nurpkgs = import nixpkgs { system = "x86_64-linux"; };
            };
          in {
            imports = [
              nur-no-pkgs.repos.heph2.modules.bind
            ];
          })
      ];
  };
  
  casper = nixosSystem {
    system = "x86_64-linux";
    modules =
      defaultModules
      ++ [
        ./casper/configuration.nix
      ] ++ [
        ../modules/base-oracle.nix
      ];
  };

  thor = nixosSystem {
    system = "x86_64-linux";
    modules = 
     defaultModules
     ++ [
        ./thor/configuration.nix
      ] ++ [
        ../modules/base-oracle.nix
      ];
  };
  
  hod = nixosSystem {
    system = "aarch64-linux";
    modules =
      defaultModules
      ++ [
        ./hod/configuration.nix
      ]
      ++ [
#        ../modules/base-oracle.nix
      ];    
  };
  
  odin = nixosSystem {
    system = "aarch64-linux";
    modules =
      defaultModules
      ++ [
        ./odin/configuration.nix
      ]
      ++ [
#        ../modules/base-oracle.nix
      ];    
  };

  #  sp4 = nixosSystem {
  sp4 = nixos-sp4 {
    system = "x86_64-linux";
    modules =
      defaultModules
      ++ [
        ./sp4/configuration.nix
        nixos-hardware.nixosModules.microsoft-surface-pro-3
	      home-manager.nixosModules.home-manager
	      {
	        home-manager.useGlobalPkgs = true;
	        home-manager.useUserPackages = true;
	        home-manager.users.heph = import ./sp4/home.nix;
	      }
      ] ++ [
	{
	   nixpkgs.overlays = overlays;
	}
      ];
  };  
}

