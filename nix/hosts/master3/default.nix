let
  role = "server";
in
{
  imports = [
    ../common.nix
    ../../common/options.nix {
      local = {
        rke2 = {
          role = role;
          tokenFile = "/join.token";
          initMaster = "master1.4amlunch.net";
        };

        network = {
          hostname = "master3";

          publicNIC = "enp1s0";
          publicIP = "10.22.20.13";

          privateNIC = "enp2s0";
          privateIP = "10.22.30.13";
        };
      };
    }

    (import ../../common/configuration.nix { inherit role; })
  ];
}
