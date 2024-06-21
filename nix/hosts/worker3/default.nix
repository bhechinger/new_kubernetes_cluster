let
  role = "agent";
in
{
  imports = [
    ../../common/options.nix {
      local = {
        rke2 = {
          role = role;
          token = "ReallyBadToken";
          serverIP = "10.22.30.11";
          extraFlags = ["--disable-kube-proxy" "--cluster-cidr=10.24.0.0/16"];
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
