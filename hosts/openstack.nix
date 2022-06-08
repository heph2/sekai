{ config, lib, pkgs, ... }:
let
  defaultId = "fe0de0e1-cf81-4d6f-b1f1-f1ecc42d07bb";
in
{
  ## configure admin ssh keys
  users.admins.pek.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCmIz2Selg5eJ77lvpJHgDJiRIOZbucMjDK5zrhTEWK heph@fenrir";

  ## openstack secrets
  data.sops_file.openstack = {
    source_file = "openstack_secrets.yaml";
  };

  resource.openstack_networking_secgroup_v2.secgroup_ALL = {
    name = "secgroup_ALL";
    description = "Security group that let pass both TCP and UDP";
  };

  resource.openstack_networking_secgroup_rule_v2.secgroup_all_rule_1 = {
    direction = "ingress";
    ethertype = "IPv4";
    remote_ip_prefix = "0.0.0.0/0";
    security_group_id = ''''${openstack_networking_secgroup_v2.secgroup_ALL.id}'';
  };
  
  openstack = {
    enable = true;
    provider = {
      authUrl = "https://keystone.cloud.garr.it:5000/v3";
      credId = ''''${data.sops_file.openstack.data["openstack.app_id"]}'';
      credSecret = ''''${data.sops_file.openstack.data["openstack.sec_id"]}'';
      region = "garr-pa1";
    };
    server = {
      "kelpie" = {
        enable = true;
        name = "kelpie";
        image = "NixOS 21 11"; # this is a costum image built using ./nixos/images/image21.11.nix and nixos-generate
        flavor = "m1.medium";
        networkId = defaultId;
        securityGroups = [
          ''''${openstack_networking_secgroup_v2.secgroup_ALL.id}''
        ];
      };
      "axel" = {
        enable = true;
        name = "axel";
        image = "NixOS 21 11";
        flavor = "m1.medium"; # 4GB Ram, 2vCPU, 80GB Storage
        networkId = defaultId;
        securityGroups = [
          ''''${openstack_networking_secgroup_v2.secgroup_ALL.id}''
        ];        
      };
    };

    ## create a file which contains the outputs from terraform
    export.nix = "./nixos/machines/nixos-machines.nix";
  };
}
