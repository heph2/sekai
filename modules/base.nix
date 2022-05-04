{ config, pkgs, lib, ... }:

{
  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "without-password";
    };
  };

  environment.systemPackages = with pkgs; [
    wget openssh
  ];
}
