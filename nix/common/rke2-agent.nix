{ lib, config, ... }:

with lib;
let
  cfg = config.local.rke2;
in
{
  services.rke2 = {
    enable = true;
    role = cfg.role;
    tokenFile = cfg.tokenFile;
    extraFlags = cfg.extraFlags;
    serverAddr = "https://${cfg.initMaster}:9345";
  };
}
