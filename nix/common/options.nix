{lib, ...}:

with lib;
{
  options.local = {
    rke2 = {
      role = mkOption {
        type = types.str;
      };

      token = mkOption {
        type = types.str;
      };

      serverIP = mkOption {
        default = "";
        type = types.str;
      };

      clusterInit = mkOption {
        default = false;
        type = types.bool;
      };

      extraFlags = mkOption {
        default = [];
        type = types.listOf types.str;
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
