{ config, lib, pkgs, inputs,... }:
{
  ## Enable sops provider
  terraform.required_providers.sops.source = "carlpett/sops";
  data.sops_file.openstack = {
    source_file = "openstack_secrets.yaml";
  };

  
  # configure admin ssh keys
  users.admins.palo.publicKey = "${lib.fileContents ./sekai_ed.pub}";
  
  openstack = {
    enable = true;
    provider = {
      authUrl = "https://keystone.cloud.garr.it:5000/v3";
      credId = "\$data.sops_file.openstack.data[openstack.app_id]";
      credSecret = "\$data.sops_file.openstack.data[openstack.sec_id]";
      region = "garr-pa";
    };
    server = {
      "test" = {
        enable = true;
        name = "test";
        image = "ubuntu-20.04";
        flavor = "m2.medium";
        networkId = "";
        securityGroups = [""];
      };
    };
    export.nix = toString ./machines/nixos-machines.nix;
  };
}
