{ inputs, lib, config, pkgs, ... }:

with lib;
with pkgs;
let
  cfg = config.local.rke2;
  net = config.local.network;
  hostname = config.networking.hostName;
  vlan = "vlan" + toString net.vlanID;
  #privateNIC = vlan + "@" + net.privateNIC;

  ciliumConfig = substituteAll {
    src = ../helm/rke2-cilium-config.yaml;
    clusterName = "hetzner";
    hubbleEnabled = "true";
    hubbleRelay = "true";
    hubbleUI = "true";
    gatewayAPI = "true";
    privateCIDR = net.privateCIDR;
    publicNIC = "public";
    privateNIC = "private";
    vlanID = builtins.toString net.vlanID;
  };

  argocd = substituteAll {
    src = ../helm/rke2-argocd.yaml;
    version = "3.35.4";
  };

  certManager = substituteAll {
    src = ../helm/rke2-cert-manager.yaml;
    version = "v1.15.1";
  };

  originCAIssuerCRDs = substituteAll {
    src = ../helm/rke2-origin-ca-issuer-crds.yaml;
    version = "0.1.1";
  };

  originCAIssuer = substituteAll {
    src = ../helm/rke2-origin-ca-issuer.yaml;
    version = "0.1.0";
  };

  gatewayAPICRDs = substituteAll {
    src = ../helm/rke2-gatewayapi-crds.yaml;
    version = "1.0.0";
  };
in
{
  boot.swraid.enable = false;

  environment.etc = {
    "rancher/rke2/config.yaml" = {
      text = ''
      disable-kube-proxy: true
      disable:
        - rke2-ingress-nginx
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
    "C /var/lib/rancher/rke2/server/manifests/rke2-argocd.yaml 0644 root root - ${argocd}"
    "C /var/lib/rancher/rke2/server/manifests/rke2-cert-manager.yaml 0644 root root - ${certManager}"
    "C /var/lib/rancher/rke2/server/manifests/rke2-origin-ca-issuer-crds.yaml 0644 root root - ${originCAIssuerCRDs}"
    "C /var/lib/rancher/rke2/server/manifests/rke2-origin-ca-issuer.yaml 0644 root root - ${originCAIssuer}"
    "C /var/lib/rancher/rke2/server/manifests/rke2-gatewayapi-crds.yaml 0644 root root - ${gatewayAPICRDs}"
  ];

  services.rke2 = {
    enable = true;
    cni = "cilium";
    role = cfg.role;
    tokenFile = cfg.tokenFile;
    serverAddr = if !cfg.clusterInit then "https://${cfg.initMaster}:9345" else "";
    nodeTaint = [
      "CriticalAddonsOnly=true:NoExecute"
      "CriticalAddonsOnly=true:NoSchedule"
    ];
  };
}
