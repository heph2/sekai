{
  description = "My sekai (world), aka my infrastructure";

  # To update all inputs:
  # $ nix flake update
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-sp4.url = "github:nixos/nixpkgs";
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
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix.url = "github:NixOS/nix/2.5.1";
    blog-flake.url = "github:heph2/blog";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
  outputs = { ... } @ args: import ./outputs.nix args;
}

 
