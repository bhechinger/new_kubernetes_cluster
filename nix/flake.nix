{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/24.05";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { nixpkgs, disko, ... }:
  {
    imports = [ ./common/network.nix ];
    networkSettings = {
      hostname = "master3";
      privateIP = "10.22.20.12";
    };

    nixosConfigurations.k3s-master = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./master/configuration.nix
      ];
    };

    nixosConfigurations.k3s-worker = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./worker/configuration.nix
      ];
    };
  };
}
