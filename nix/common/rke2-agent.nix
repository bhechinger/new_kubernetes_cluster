{ lib, config, ... }:

with lib;
let
  cfg = config.local.rke2;
  net = config.local.network;
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

  environment.etc = {
    "rancher/rke2/config.yaml" = {
      text = ''
      node-ip: ${net.privateIP}
      node-external-ip: ${net.publicIP}
      '';

      mode = "0644";
    };
  };

  services.rke2 = {
    enable = true;
    role = cfg.role;
    tokenFile = cfg.tokenFile;
    serverAddr = "https://${cfg.initMaster}:9345";
  };
}
