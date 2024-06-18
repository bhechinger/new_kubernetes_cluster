{ lib, system, ...}:
{
  imports = [
    ../../common/options.nix {
      local = {
        k3s = {
          role = "server";
          token = "ReallyBadToken";
          serverIP = "";
          clusterInit = true;
        };

        network = {
          hostname = "master1";
          privateIP = "10.22.20.11";
          publicNIC = "ens3";
          privateNIC = "ens4";
        };
      };
    }

    ../../common/configuration.nix
    ../../common/network.nix
    ../../common/k3s.nix
  ];

}
