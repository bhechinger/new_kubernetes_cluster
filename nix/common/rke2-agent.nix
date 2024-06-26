{ lib, config, ... }:

with lib;
let
  cfg = config.local.rke2;
in
{
  boot = {
    # Needed for Rook/Ceph
    kernelModules = [ "rbd" ];

    swraid = {
      enable = true;
      mdadmConf = ''
      MAILADDR = wonko@4amlunch.net
      MAILFROM = mdadm@$4amlunch.net
      '';
    };

#    loader.grub.mirroredBoots = [
#      {
#        devices = [
#          "nodev"
##          "/dev/vda/by-partlabel/disk-one-boot"
##          "/dev/vda"
#        ];
#        path = "/boot1";
#        efiSysMountPoint = "/boot1";
#      }
#      {
#        devices = [
#          "nodev"
##          "/dev/disk/by-partlabel/disk-two-boot"
##          "/dev/vdb"
#        ];
#        path = "/boot2";
#        efiSysMountPoint = "/boot2";
#      }
#    ];
  };

  services.rke2 = {
    enable = true;
    role = cfg.role;
    tokenFile = cfg.tokenFile;
    extraFlags = cfg.extraFlags;
    serverAddr = "https://${cfg.initMaster}:9345";
  };
}
