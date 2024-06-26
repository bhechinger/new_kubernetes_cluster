{ role }: { modulesPath, config, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./users.nix
    ./services.nix
    ./network.nix
    ./rke2-${role}.nix
    ../disk-config/${role}.nix
  ];

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
#    efiSupport = true;
#    efiInstallAsRemovable = true;
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.e2fsprogs
  ];

  system.stateVersion = "24.05";
}
