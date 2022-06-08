{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
    configurationLimit = 1;
  };

  fileSystems."/boot" = { device = "/dev/sda15"; fsType = "vfat"; };
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };
  
  boot.initrd.kernelModules = [ "nvme" ];
  
#  boot.loader.efi.efiSysMountPoint = "/boot/efi";
#  fileSystems."/boot" = { device = "/dev/sda1"; fsType = "vfat"; };
#  zramSwap.enable = true;
  boot.cleanTmpDir = true;
#  swapDevices = [ { device = "/dev/zram0"; } ];
  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];    
  };

  system.stateVersion = "21.11";
}
