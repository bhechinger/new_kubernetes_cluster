{ lib, system, ...}:
{
  imports = [
    (import ../../common/network.nix {
      hostname = "worker1";
      privateIP = "10.22.20.21";
      publicNIC = "ens3";
      privateNIC = "ens4";
    } )

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
