{ config, lib, pkgs, inputs,... }:
{
  ## Enable sops provider
  terraform.required_providers.sops.source = "carlpett/sops";
  data.sops_file.openstack = {
    source_file = "openstack_secrets.yaml";
  };

  # configure admin ssh keys
  users.admins.pek.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCmIz2Selg5eJ77lvpJHgDJiRIOZbucMjDK5zrhTEWK heph@fenrir";
  
  openstack = {
    enable = true;
    provider = {
      authUrl = "https://keystone.cloud.garr.it:5000/v3";
      credId = "\${data.sops_file.openstack.data[\"openstack.app_id\"]}";
      credSecret = "\${data.sops_file.openstack.data[\"openstack.sec_id\"]}";
      region = "garr-pa1";
    };
    server = {
      "kelpie" = {
        enable = true;
        name = "kelpie";
        image = "NixOS 21 11"; # this is a costum image built using ./nixos/images/image21.11.nix and nixos-generate
        flavor = "m1.medium";
        networkId = "fe0de0e1-cf81-4d6f-b1f1-f1ecc42d07bb";
        securityGroups = ["c5e4d2ed-6f5b-4efe-831f-5ae93010fe4a"];
      };
      "axel" = {
        enable = true;
        name = "axel";
        image = "NixOS 21 11";
        flavor = "m1.medium";
        networkId = "fe0de0e1-cf81-4d6f-b1f1-f1ecc42d07bb";
        securityGroups = ["c5e4d2ed-6f5b-4efe-831f-5ae93010fe4a"];        
      };
    };

    ## create a file which contains the outputs from terraform
    export.nix = "./nixos/machines/nixos-machines.nix";
  };
}
