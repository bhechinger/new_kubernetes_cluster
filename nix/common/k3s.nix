{ config, ... }:

let
  cfg = config.local.k3s;
in
{
  services.k3s = {
    enable = true;
    role = cfg.role;
    token = cfg.token;
    serverAddr = "https://${cfg.serverIP}:6443";
    clusterInit = cfg.clusterInit;
  };
}
