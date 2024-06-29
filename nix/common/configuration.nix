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
  };

  boot = {
      kernelParams = [ "mitigations=off" ];
      kernelModules = [ "cls_bpf" "sch_ingress" "algif_hash" "xt_TPROXY" "xt_CT" "xt_mark" "xt_socket" "sch_fq" ];
      kernelPackages = pkgs.linuxKernel.packages.linux_6_8;
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  system.stateVersion = "24.05";
}
