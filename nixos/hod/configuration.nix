{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  
  boot.initrd.kernelModules = [ "nvme" ];
  
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/UEFI";
     fsType = "vfat";
  };
  
  fileSystems."/" = {
    device = "/dev/disk/by-label/cloudimg-rootfs";
    fsType = "ext4";
  };
  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];    
  };

  system.stateVersion = "21.11";
}
