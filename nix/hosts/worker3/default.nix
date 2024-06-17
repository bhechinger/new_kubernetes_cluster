{ lib, system, ...}:
{
  imports = [
    (import ../../common/network.nix {
      hostname = "worker3";
      privateIP = "10.22.20.23";
      publicNIC = "ens3";
      privateNIC = "ens4";
    })

    ../../worker/configuration.nix
  ];

}
