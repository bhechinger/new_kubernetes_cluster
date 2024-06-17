{ inputs, config, lib, pkgs, pkgs-brian, smc, ... }:

{
  users.users = {
    wonko = {
      isNormalUser = true;
      description = "Brian Hechinger";
      password = "password";
      extraGroups = [
        "wheel"
        "users"
      ];

      openssh.authorizedKeys.keys = [
        (builtins.readFile ../ssh/yubikey.pub)
      ];
    };
  };
}
