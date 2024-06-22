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
          hostname = "worker2";
          privateIP = "10.22.30.22";
          publicNIC = "ens3";
          privateNIC = "ens4";
        };
      };
    }

    (import ../../common/configuration.nix { inherit role; })
  ];
}
