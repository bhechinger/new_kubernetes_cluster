{
  imports = [
    ../../common/options.nix {
      local = {
        network = {
          clusterCIDR = "10.55.0.0/16";
          serviceCIDR = "10.65.0.0/16";
        };
      };
    }
  ];
}
