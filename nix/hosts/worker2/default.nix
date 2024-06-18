{ lib, system, ...}:
{
  imports = [
    (import ../../common/network.nix {
      hostname = "worker2";
      privateIP = "10.22.20.22";
      publicNIC = "ens3";
      privateNIC = "ens4";
    })

    (import ../../common/k3s.nix {
      role = "master";
      token = "";
      serverAddr = ""; # Ignored for init node
      clusterInit = true;
    })

    (import ../../common/configuration.nix {
      role = "worker";
    })
  ];

}
