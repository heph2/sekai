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

## Machines

All the machines are managed using 'deploy-rs' and can be easily deployed
with:
	$ deploy .#<machine_name> -- --impure

Most of the machines are impure so you must provide the impure flag.

### Surface Pro 4 (SP4)

That's my surface pro 4 (with m3 cpu) using nixos-hardware and nixos.
I'm currently using it for university note-taking on xournal++ and it's 
rocking a Sway/Wayland setup, with almost full touch support.

I'm currently do not use any common module on it, so the whole configuration is in 'nixos/sp4' directory.

For deploying:
	$ deploy '.#sp4' -- --impure -j0

I'm only using the -j0 flag only when i'm building from the sp4 itself, which has very poor performance in terms of compiling, so i'm building all the stuff directly using the Desktop (which isn't in the flake).

### Kelpie (GARR)

This is a VPS offered by GARR as a student, and it's serving as a web server for my blog, as a wireguard server, pounce
server and also as a nameserver for my domains.

	$ deploy '.#kelpie' -- --impure

