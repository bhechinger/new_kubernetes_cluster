{ lib, config, ... }:

with lib;
let
  cfg = config.local.rke2;
in
{
  services.rke2 = {
    enable = true;
    role = cfg.role;
    token = cfg.token;
    extraFlags = cfg.extraFlags;
    serverAddr = "https://${cfg.serverIP}:6443";
  };
}
