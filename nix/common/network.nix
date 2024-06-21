{ config, ... }:

let
  cfg = config.local.network;
  vlan = "vlan" + toString cfg.vlanID;
in
{
  networking = {
    hostName = cfg.hostname;
    domain = "4amlunch.net";
    useDHCP = false;

    vlans = {
      "${vlan}" = {
        id = cfg.vlanID;
        interface = cfg.privateNIC;
      };
    };

    interfaces = {
      "${cfg.publicNIC}".useDHCP = true;
      "${vlan}".ipv4.addresses = [{
        address = cfg.privateIP;
        prefixLength = 24;
      }];
    };

    firewall.enable = false;
  };
}
