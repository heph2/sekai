# Pek no sekai

My home network and vps infrastructure, completely managed using nixos,
terraform and flakes.
It's almost completely declarative, including secrets management.

## Terrafom and Terranix

My VPSs are gently offered by GARR, as i'm a comp-sci student; and
they're all created using terraform's openstack provider and terranix
as a nix wrapper.
Thanks to terranix-openstack i can easily manage the creation of terraform
resources thorugh nix and it's module system.

## Secrets

Actually secrets are managed using sops; in particular using
terraform-sops provider and sops-nix for provisioning pourposes.
