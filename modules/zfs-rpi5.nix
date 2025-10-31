{ inputs, ... }:
{
  flake.modules.nixos.zfs-rpi5 = {
    imports = [
      inputs.disko.nixosModules.disko
    ];

    boot.supportedFilesystems = [ "zfs" ];

    services.zfs.autoScrub.enable = true;
    services.zfs.trim.enable = true;

    disko.devices = {
      disk.nvme0 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            FIRMWARE = {
              label = "FIRMWARE";
              priority = 1;

              type = "0700"; # Microsoft basic data
              attributes = [
                0 # Required Partition
              ];

              size = "1024M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/firmware";
                mountOptions = [
                  "noatime"
                  "noauto"
                  "x-systemd.automount"
                  "x-systemd.idle-timeout=1min"
                ];
              };
            };
            ESP = {
              label = "ESP";

              type = "EF00"; # EFI System Partition (ESP)
              attributes = [
                2 # Legacy BIOS Bootable, for U-Boot to find extlinux config
              ];

              size = "1024M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "noatime"
                  "noauto"
                  "x-systemd.automount"
                  "x-systemd.idle-timeout=1min"
                  "umask=0077"
                ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool"; # zroot
              };
            };
          };
        };
      };

      zpool = {
        rpool = {
          type = "zpool";

          # zpool properties
          options = {
            ashift = "14";
            autotrim = "on";
          };

          # zfs properties
          rootFsOptions = {
            # https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/
            compression = "lz4";
            atime = "off";
            xattr = "sa";
            acltype = "posixacl";
            # https://rubenerd.com/forgetting-to-set-utf-normalisation-on-a-zfs-pool/
            normalization = "formD";
            dnodesize = "auto";
            mountpoint = "none";
            canmount = "off";
          };

          datasets = {

            local = {
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            "local/nix" = {
              type = "zfs_fs";
              options = {
                reservation = "128M";
                mountpoint = "legacy";
              };
              mountpoint = "/nix";
            };

            system = {
              type = "zfs_fs";
              options = {
                mountpoint = "none";
              };
            };
            "system/root" = {
              type = "zfs_fs";
              options = {
                mountpoint = "legacy";
              };
              mountpoint = "/";
            };
            "system/var" = {
              type = "zfs_fs";
              options = {
                mountpoint = "legacy";
              };
              mountpoint = "/var";
            };

            safe = {
              type = "zfs_fs";
              options = {
                copies = "2";
                mountpoint = "none";
              };
            };
            "safe/home" = {
              type = "zfs_fs";
              options = {
                mountpoint = "legacy";
              };
              mountpoint = "/home";
            };
            "safe/var/lib" = {
              type = "zfs_fs";
              options = {
                mountpoint = "legacy";
              };
              mountpoint = "/var/lib";
            };
          };
        };
      };
    };
  };
}
