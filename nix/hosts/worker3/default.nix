let
  role = "agent";
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
          hostname = "worker3";

          publicNIC = "enp1s0";
          publicIP = "10.22.20.23";

          privateNIC = "enp2s0";
          privateIP = "10.22.30.23";
        };
      };
    }

    (import ../../common/configuration.nix { inherit role; })
  ];
}

#--node-ip value, -i value                     (agent/networking) IPv4/IPv6 addresses to advertise for node
#--node-external-ip value                      (agent/networking) IPv4/IPv6 external IP addresses to advertise for node