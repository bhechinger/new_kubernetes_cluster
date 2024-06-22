{ inputs, lib, config, ... }:

with lib;
let
  cfg = config.local.rke2;
  hostname = config.networking.hostName;
in
{
  environment.etc = {
    "rancher/rke2/config.yaml" = {
      text = ''
      disable-kube-proxy: true
      tls-san:
        - ${hostname}.4amlunch.net
        - ${hostname}
      '';

      mode = "0644";
    };
  };

  disabledModules = ["services/cluster/rke2/default.nix"];
  imports = ["${inputs.nixpkgs-brian}/nixos/modules/services/cluster/rke2/default.nix"];

  services.rke2 = {
    enable = true;
    cni = "cilium";
    role = cfg.role;
    tokenFile = cfg.tokenFile;
    extraFlags = cfg.extraFlags;
    serverAddr = if !cfg.clusterInit then "https://${cfg.initMaster}:9345" else "";
    nodeTaint = [
      "CriticalAddonsOnly=true:NoExecute"
    ];
  };
}
