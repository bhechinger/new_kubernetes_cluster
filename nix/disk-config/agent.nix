{ lib, ... }:
{
  disko.devices = {
    disk = {
      one = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "mdraid";
                name = "boot";
              };
            };
            mdadm = {
              size = "60G";
              content = {
                type = "mdraid";
                name = "system";
              };
            };
            ceph = {
              size = "100%";
#              content = {
#                type = "filesystem";
#                format = "ext4";
#              };
            };
          };
        };
      };
      two = {
        type = "disk";
        device = "/dev/vdb";
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              size = "1M";
              type = "EF02"; # for grub MBR
              priority = 1; # Needs to be first partition
            };
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "mdraid";
                name = "boot";
              };
            };
            mdadm = {
              size = "60G";
              content = {
                type = "mdraid";
                name = "system";
              };
            };
            ceph = {
              size = "100%";
#              content = {
#                type = "filesystem";
#                format = "ext4";
#              };
            };
          };
        };
      };
    };
    mdadm = {
      boot = {
        type = "mdadm";
        level = 1;
        metadata = "1.0";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
        };
      };
      system = {
        type = "mdadm";
        level = 1;
        content = {
          type = "gpt";
          partitions.primary = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
