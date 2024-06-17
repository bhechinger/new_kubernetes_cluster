{ lib, config, ... }:
with lib;
let
  cfg = config.networkSettings;
in {
  options.networkSettings = {
    hostName = mkOption {
      type = types.str;
    };
    privateIP = mkOption {
      type = types.str;
    };
  };

  networking = {
    hostName = cfg.hostName;
    domain = "4amlunch.net";
    useDHCP = false;

    vlans = {
      vlan4000 = { id=4000; interface="ens4"; };
    };

    interfaces = {
      ens3.useDHCP = true;
      vlan4000.ipv4.addresses = [{
        address = cfg.privateIP;
        prefixLength = 24;
      }];
    };

    firewall.enable = true;
  };
}
