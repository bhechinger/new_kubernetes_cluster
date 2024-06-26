let
  role = "server";
in
{
  imports = [
    ../../common/options.nix {
      local = {
        rke2 = {
          role = role;
          clusterInit = true;
          extraFlags = ["--cluster-cidr=10.24.0.0/16"];
        };

        network = {
          hostname = "master1";
          privateIP = "10.22.30.11";
          publicNIC = "enp1s0";
          privateNIC = "enp2s0";
        };
      };
    }

    (import ../../common/configuration.nix { inherit role; })
  ];
}
