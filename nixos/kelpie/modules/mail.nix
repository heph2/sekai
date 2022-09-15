{ config, pkgs, lib, ... }:
{
  mailserver = {
    enable = true;
    fqdn = "mail.pek.mk";
    domains = [ "pek.mk" ];

    loginAccounts = {
      "test@pek.mk" = {
        hashedPasswordFile = "";
      };
    };
  };
}
