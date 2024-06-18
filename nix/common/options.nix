{lib, ...}:

with lib;
{
  options.local = {
    k3s = {
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
    };
  };
}
