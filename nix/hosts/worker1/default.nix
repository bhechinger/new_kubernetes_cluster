{ lib, system, ...}:
{
  imports = [
    (import ../../common/network.nix {
      hostname = "worker1";
      privateIP = "10.22.20.21";
      publicNIC = "ens3";
      privateNIC = "ens4";
    } )

    ../../worker/configuration.nix
  ];

}
