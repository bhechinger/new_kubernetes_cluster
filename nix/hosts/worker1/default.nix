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
          hostname = "worker1";
          privateIP = "10.22.30.21";
          publicNIC = "enp1s0";
          privateNIC = "enp2s0";
        };
      };
    }

    (import ../../common/configuration.nix { inherit role; })
  ];
}
