#!/usr/bin/env zsh

hostname="kelpie"
buildHost="kelpie"

function deploy() {
    drv=$(nix eval .#nixosConfigurations.$hostname.config.system.build.toplevel.drvPath --impure | tr -d '"')
    nix copy --derivation -s --to "ssh://$buildHost" "$drv"
    ssh $buildHost nix build --no-link "$drv"
    if [ "$action" = switch -o "$action" = boot -o "$action" = test ]; then
	ssh $buildHost $drv/bin/switch-to-configuration "$action"	
    fi
}

deploy
