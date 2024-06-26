{ inputs, lib, config, pkgs, ... }:

with lib;
let
  cfg = config.local.rke2;
  hostname = config.networking.hostName;
  ciliumKubeProxy = pkgs.writeTextFile {
    name = "rke2-cilium-config.yaml";
    text = ''
        apiVersion: helm.cattle.io/v1
        kind: HelmChartConfig
        metadata:
          name: rke2-cilium
          namespace: kube-system
        spec:
          valuesContent: |-
            kubeProxyReplacement: true
            k8sServiceHost: 127.0.0.1
            k8sServicePort: 6443
            hubble:
              enabled: true
              relay:
                enabled: true
              ui:
                enabled: true
            auto-direct-node-routes: true
            direct-routing-device: vlan4000@ens4
    '';
  };
in
{
  boot.swraid.enable = false;

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
    ciliumConfig = ciliumKubeProxy;
    role = cfg.role;
    tokenFile = cfg.tokenFile;
    extraFlags = cfg.extraFlags;
    serverAddr = if !cfg.clusterInit then "https://${cfg.initMaster}:9345" else "";
    nodeTaint = [
      "CriticalAddonsOnly=true:NoExecute"
    ];
  };
}
