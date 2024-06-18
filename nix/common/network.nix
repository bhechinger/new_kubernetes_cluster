{ config, ... }:

let
  cfg = config.local.network;
in
{
  networking = {
    hostName = cfg.hostname;
    domain = "4amlunch.net";
    useDHCP = false;

    vlans = {
      vlan4000 = { id=4000; interface=cfg.privateNIC; };
    };

    interfaces = {
      ens3.useDHCP = true;
      vlan4000.ipv4.addresses = [{
        address = cfg.privateIP;
        prefixLength = 24;
      }];
    };

    firewall.enable = false;
  };
}
