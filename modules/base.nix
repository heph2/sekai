{ config, pkgs, lib, ... }:

{
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCmIz2Selg5eJ77lvpJHgDJiRIOZbucMjDK5zrhTEWK heph@fenrir"
  ];
  
  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "prohibit-password";
    };
  };
  
  environment.systemPackages = with pkgs; [
    wget openssh
  ];

  time.timeZone = "Europe/Rome";
}
