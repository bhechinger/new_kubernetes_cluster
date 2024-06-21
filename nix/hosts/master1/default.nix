let
  role = "server";
in
{
  imports = [
    ../../common/options.nix {
      local = {
        rke2 = {
          role = role;
          token = "ReallyBadToken";
          clusterInit = true;
          extraFlags = ["--disable-kube-proxy" "--cluster-cidr=10.24.0.0/16"];
        };

        network = {
          hostname = "master1";
          privateIP = "10.22.30.11";
          publicNIC = "ens3";
          privateNIC = "ens4";
        };
      };
    }

    (import ../../common/configuration.nix { inherit role; })
  ];
}
