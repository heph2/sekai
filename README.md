# Pek no sekai

My home network and vps infrastructure, completely managed using NixOS,
terraform and flakes.
It's almost completely declarative, including secrets management.

## Terraform and Terranix

My VPSs are gently offered by [GARR](https://cloud.garr.it/), as i'm a comp-sci student; and
they're all created using terraform's openstack [provider](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs) nd [terranix](https://terranix.org/).
as a nix wrapper.
Thanks to [terranix-openstack](https://github.com/heph2/terranix-openstack) i can easily manage the creation of terraform
resources through nix and it's module system.

## Secrets

Actually secrets are managed using sops; in particular using
terraform-sops provider and sops-nix for provisioning pourposes.
