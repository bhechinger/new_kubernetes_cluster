let
  role = "server";
in
{
  imports = [
    ../../common/options.nix {
      local = {
        rke2 = {
          role = role;
          tokenFile = "/join.token";
          initMaster = "master1.4amlunch.net";
          extraFlags = ["--cluster-cidr=10.24.0.0/16"];
        };

        network = {
          hostname = "master2";
          privateIP = "10.22.30.12";
          publicNIC = "enp1s0";
          privateNIC = "enp2s0";
        };
      };
    }

    (import ../../common/configuration.nix { inherit role; })
  ];
}
