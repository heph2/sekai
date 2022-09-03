{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/df1665c4-1322-4643-95b7-de0ef498aa37";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/BE0E-DD1D";
      fsType = "vfat";
    };

#  fileSystems."/home/heph/var" =
#    {
#      device = "/dev/disk/by-uuid/88e0df37-e8cf-4c23-8abf-d8adf021f3ce";
#      fsType = "ext4";
#    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.video.hidpi.enable = lib.mkDefault true;
}
