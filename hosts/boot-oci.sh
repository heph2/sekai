#!/usr/bin/env bash
sed -i 's/^.*ssh-/ssh-/g' /root/.ssh/authorized_keys
curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-21.11 bash -x
