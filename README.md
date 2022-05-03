# Pek no sekai

My home network and vps infrastructure, completely managed using NixOS,
terraform and flakes.
It's almost completely declarative, including secrets management.

## Terraform and Terranix

My VPSs are gently offered by [GARR](https://cloud.garr.it/), as i'm a comp-sci student; and
they're all created using terraform's openstack [provider](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs) and [terranix](https://terranix.org/)
as a nix wrapper.
Thanks to [terranix-openstack](https://github.com/heph2/terranix-openstack) i can easily manage the creation of terraform
resources through nix and it's module system.

### Usage
	
	$ nix build -o config.tf.json
	$ terraform init && terraform apply

This will create the openstack's resources defined in `config.nix`

## Secrets

Actually secrets are managed using [sops](https://github.com/mozilla/sops); in particular using
terraform's sops [provider](https://registry.terraform.io/providers/carlpett/sops/latest/docs) and [sops-nix](https://github.com/Mic92/sops-nix) for provisioning pourposes.
