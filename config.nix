{ config, lib, pkgs, inputs,... }:
{
  imports = [
    ./hosts/openstack.nix
    ./hosts/oracle.nix
  ];
  
  ## Enable sops provider
  terraform.required_providers.sops.source = "carlpett/sops";
}
