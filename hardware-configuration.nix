# hardware-configuration.nix — placeholder.
# Regenerate on the target machine and overwrite this file:
#   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
# The stub below only exists so `nix flake check` evaluates.
{ ... }:
{
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
