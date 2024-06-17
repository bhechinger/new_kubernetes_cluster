{ hostname, privateIP, publicNIC, privateNIC, ...}: { config, ... }:

{
  config.networking = {
    hostName = hostname;
    domain = "4amlunch.net";
    useDHCP = false;

    vlans = {
      vlan4000 = { id=4000; interface=publicNIC; };
    };

    interfaces = {
      ens3.useDHCP = true;
      vlan4000.ipv4.addresses = [{
        address = privateIP;
        prefixLength = 24;
      }];
    };

    firewall.enable = true;
  };
}
