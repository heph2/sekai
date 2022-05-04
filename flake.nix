{
  description = "My sekai (world), aka my infrastructure";

  # To update all inputs:
  # $ nix flake update
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    terranix = {
      url = "github:terranix/terranix/develop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    module-openstack.url = "github:heph2/terranix-openstack";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    deploy-rs.url = "github:serokell/deploy-rs";
    nix.url = "github:NixOS/nix/2.5.1";
  };
  outputs = { ... } @ args: import ./outputs.nix args;
}

 
