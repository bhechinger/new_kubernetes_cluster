{ lib, system, ...}:
{
  imports = [
    (import ../../common/network.nix {
      hostname = "master1";
      privateIP = "10.22.20.11";
      publicNIC = "ens3";
      privateNIC = "ens4";
    } )

    ../../master/configuration.nix
  ];

}
