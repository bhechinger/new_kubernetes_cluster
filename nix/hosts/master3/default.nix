{ lib, system, ...}:
{
  imports = [
    (import ../../common/network.nix {
      hostname = "master3";
      privateIP = "10.22.20.13";
      publicNIC = "ens3";
      privateNIC = "ens4";
    } )

    ../../master/configuration.nix
  ];

}
