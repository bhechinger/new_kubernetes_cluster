{ lib, system, ...}:
{
  imports = [
    (import ../../common/network.nix {
      hostname = "master2";
      privateIP = "10.22.20.12";
      publicNIC = "ens3";
      privateNIC = "ens4";
    } )

    ../../master/configuration.nix
  ];

}
