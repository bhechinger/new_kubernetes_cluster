let
  role = "server";
in
{
  imports = [
    ../common.nix
    ../../common/options.nix {
      local = {
        rke2 = {
          role = role;
          clusterInit = true;
        };

        network = {
          hostname = "master1";

          publicNIC = "enp1s0";
          publicIP = "10.22.20.11";

          privateNIC = "enp2s0";
          privateIP = "10.22.30.11";
        };
      };
    }

    (import ../../common/configuration.nix { inherit role; })
  ];
}
