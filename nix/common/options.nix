{lib, ...}:

with lib;
{
  options.local = {
    rke2 = {
      role = mkOption {
        type = types.enum [ "server" "agent" ];
      };

      tokenFile = mkOption {
        type = types.nullOr types.path;
        default = null;
      };

      initMaster = mkOption {
        type = types.str;
        default = "";
      };

      clusterInit = mkOption {
        type = types.bool;
        default = false;
      };
    };

    network = {
      hostname = mkOption {
        type = types.str;
      };

      publicIP = mkOption {
        type = types.str;
      };

      privateIP = mkOption {
        type = types.str;
      };

      privateCIDR = mkOption {
        type = types.str;
      };

      publicNIC = mkOption {
        type = types.str;
      };

      privateNIC = mkOption {
        type = types.str;
      };

      vlanID = mkOption {
        default = 4000;
        type = types.int;
      };

      clusterCIDR = mkOption {
        type = types.str;
        default = "10.42.0.0/16";
      };

      serviceCIDR = mkOption {
        type = types.str;
        default = "10.43.0.0/16";
      };
    };
  };
}
