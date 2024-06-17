{ inputs, config, lib, pkgs, pkgs-brian, smc, ... }:
{
  services = {
#    zerotierone = {
#      enable = true;
#      joinNetworks = [
#        "a84ac5c10a853bc1"
#      ];
#    };

    openssh.enable = true;
  };
}
