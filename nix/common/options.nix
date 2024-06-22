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

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
      };
    };

    network = {
      hostname = mkOption {
        type = types.str;
      };

      privateIP = mkOption {
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
    };
  };
}
