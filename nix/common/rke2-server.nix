{ inputs, lib, config, ... }:

with lib;
let
  cfg = config.local.rke2;
in
{
  disabledModules = ["nixos/modules/services/cluster/rke2/default.nix"];
  imports = ["${inputs.nixpkgs-brian}/nixos/modules/services/cluster/rke2/default.nix"];

  services.rke2 = {
    enable = true;
    cni = "cilium";
    role = cfg.role;
    token = cfg.token;
    extraFlags = cfg.extraFlags;
    serverAddr = if !cfg.clusterInit then "https://${cfg.serverIP}:6443" else "";
#    nodeTaint = [
#      "key1=value1:NoSchedule"
#    ];
  };
}
