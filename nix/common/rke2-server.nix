{ inputs, lib, config, pkgs, ... }:

with lib;
with pkgs;
let
  cfg = config.local.rke2;
  net = config.local.network;
  hostname = config.networking.hostName;

  ciliumConfig = substituteAll {
    src = ../helm/rke2-cilium-config.yaml;
    clusterName = "hetzner";
    hubbleEnabled = "true";
    hubbleRelay = "true";
    hubbleUI = "true";
    directRoutingDevice = "vlan${builtins.toString net.vlanID}@${net.privateNIC}";
    gatewayAPI = "true";
    clusterCIDR = "${net.clusterCIDR}";
    privateCIDR = "${net.privateCIDR}";
    privateNIC = "${net.privateNIC}";
    publicNIC = "${net.publicNIC}";
  };

  argocd = substituteAll {
    src = ../helm/argocd.yaml;
    version = "3.35.4";
  };

  argocdConfig = substituteAll {
    src = ../helm/argocd-config.yaml;
  };

  certManager = substituteAll {
    src = ../helm/cert-manager.yaml;
    version = "v1.15.1";
  };

  certManagerConfig = substituteAll {
    src = ../helm/cert-manager-config.yaml;
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
      cluster-cidr: ${net.clusterCIDR}
      service-cidr: ${net.serviceCIDR}
      etcd-expose-metrics: true
      node-ip: ${net.privateIP}
      node-external-ip: ${net.publicIP}
      '';

      mode = "0644";
    };
  };

  disabledModules = ["services/cluster/rke2/default.nix"];
  imports = ["${inputs.nixpkgs-brian}/nixos/modules/services/cluster/rke2/default.nix"];

  systemd.tmpfiles.rules = [
    "C /var/lib/rancher/rke2/server/manifests/rke2-cilium-config.yaml 0644 root root - ${ciliumConfig}"
    "C /var/lib/rancher/rke2/server/manifests/argocd.yaml 0644 root root - ${argocd}"
    "C /var/lib/rancher/rke2/server/manifests/argocd-config.yaml 0644 root root - ${argocdConfig}"
    "C /var/lib/rancher/rke2/server/manifests/cert-manager.yaml 0644 root root - ${certManager}"
    "C /var/lib/rancher/rke2/server/manifests/cert-manager-config.yaml 0644 root root - ${certManagerConfig}"
  ];

  services.rke2 = {
    enable = true;
    cni = "cilium";
#    ciliumConfig = ciliumKubeProxy;
    role = cfg.role;
    tokenFile = cfg.tokenFile;
    serverAddr = if !cfg.clusterInit then "https://${cfg.initMaster}:9345" else "";
    nodeTaint = [
      "CriticalAddonsOnly=true:NoExecute"
    ];
  };
}
