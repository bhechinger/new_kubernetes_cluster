{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/24.05";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { nixpkgs, disko, ... }:
  {
      nixosConfigurations =
        let
          nixos = { system, hostname }: nixpkgs.lib.nixosSystem {
            system = system;
            modules = [
              disko.nixosModules.disko
              ./hosts/${hostname}
            ];
          };
        in
        {
          master1 = nixos {
            system = "x86_64-linux";
            hostname = "master1";
          };

          master2 = nixos {
            system = "x86_64-linux";
            hostname = "master2";
          };

          master3 = nixos {
            system = "x86_64-linux";
            hostname = "master3";
          };

          worker1 = nixos {
            system = "x86_64-linux";
            hostname = "worker1";
          };

          worker2 = nixos {
            system = "x86_64-linux";
            hostname = "worker2";
          };

          worker3 = nixos {
            system = "x86_64-linux";
            hostname = "worker3";
          };
        };

  };
}
