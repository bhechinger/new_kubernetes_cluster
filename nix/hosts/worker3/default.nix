let
  role = "agent";
in
{
  imports = [
    ../../common/options.nix {
      local = {
        rke2 = {
          role = role;
          tokenFile = "/join.token";
          initMaster = "master1.4amlunch.net";
#          extraFlags = ["--disable-kube-proxy" "--cluster-cidr=10.24.0.0/16"];
        };

        network = {
          hostname = "worker3";
          privateIP = "10.22.30.23";
          publicNIC = "ens3";
          privateNIC = "ens4";
        };
      };
    }

    (import ../../common/configuration.nix { inherit role; })
  ];
}

#--node-ip value, -i value                     (agent/networking) IPv4/IPv6 addresses to advertise for node
#--node-external-ip value                      (agent/networking) IPv4/IPv6 external IP addresses to advertise for node