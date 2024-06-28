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
  };

  services.rke2 = {
    enable = true;
    role = cfg.role;
    tokenFile = cfg.tokenFile;
    serverAddr = "https://${cfg.initMaster}:9345";
  };
}
