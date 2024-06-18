{ lib, system, ...}:
{
  imports = [
    (import ../../common/network.nix {
      hostname = "worker3";
      privateIP = "10.22.20.23";
      publicNIC = "ens3";
      privateNIC = "ens4";
    })

    (import ../../common/k3s.nix {
      role = "worker";
      token = "";
      serverAddr = ""; # Ignored for init node
      clusterInit = true;
    })

    (import ../../common/configuration.nix {
      role = "worker";
    })
  ];

}
