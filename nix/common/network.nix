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

    bridges = {
      "public" = {
        interfaces = [ "${cfg.publicNIC}" ];
      };
      "private" = {
        interfaces = [ "${vlan}" ];
      };
    };

    vlans = {
      "${vlan}" = {
        id = cfg.vlanID;
        interface = cfg.privateNIC;
      };
    };

    interfaces = {
      public.useDHCP = true;
      private.ipv4.addresses = [{
        address = cfg.privateIP;
        prefixLength = 24;
      }];
    };

    firewall.enable = false;

    extraHosts = ''
      10.22.20.11 master1.4amlunch.net master1
      10.22.20.12 master2.4amlunch.net master2
      10.22.20.13 master3.4amlunch.net master3
      10.22.20.21 worker1.4amlunch.net worker1
      10.22.20.21 worker2.4amlunch.net worker2
      10.22.20.21 worker3.4amlunch.net worker3
    '';
  };
}
