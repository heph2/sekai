{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  networking.hostName = "freeinstance0";
  boot = {
    loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
    };
    initrd.kernelModules = [ "nvme" ];
    cleanTmpDir = true;    
  };
  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/mapper/ocivolume-root";
    fsType = "xfs";
  };
  # swapDevices = [
  #   { device = "/dev/sda2"; }
  # ];  
}
