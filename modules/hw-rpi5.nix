{ inputs, ... }:
{
  flake.modules.nixos.hw-rpi5 =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
        inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
      ];

      # 4KB kernel page size for Raspberry Pi 5
      # The standard 16KB cause issues with some software, like zfs + qemu-img
      boot.kernelPackages = pkgs.linuxPackages_rpi4;

      # Recommended default: https://github.com/nvmd/nixos-raspberrypi/tree/develop#provides-bootloader-infrastructure}
      boot.loader.raspberryPi.bootloader = "kernel";
    };
}
