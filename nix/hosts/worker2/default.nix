{ lib, system, ...}:
{
  imports = [
    (import ../../common/network.nix {
      hostname = "worker2";
      privateIP = "10.22.20.22";
      publicNIC = "ens3";
      privateNIC = "ens4";
    })

    ../../worker/configuration.nix
  ];

}
