{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  inputs.nixos.follows = "nixpkgs";
  inputs.nix.url = "nix/2.12-maintenance";
  inputs.nosys.url = "github:divnix/nosys";
  inputs.registry.url = "github:nixos/flake-registry";
  inputs.registry.flake = false;

  outputs = inputs @ {nosys, ...}:
    nosys (inputs
      // {
        systems = ["x86_64-linux" "aarch64-linux"];
      }) ({
      nixpkgs,
      nix,
      registry,
      ...
    }: {
      nixosConfigurations = let
        inherit (nixpkgs.legacyPackages) pkgs;
      in
        nixpkgs.lib.nixosSystem {
          inherit (pkgs) system;
          modules = [
            "${nixpkgs}/nixos/modules/virtualisation/amazon-image.nix"
            {
              system.stateVersion = "22.11";
              imports = [./modules/nix.nix];
              nix = {
                registry = let
                  sansNixpkgs = builtins.removeAttrs inputs ["nixpkgs" "self"];
                in
                  builtins.mapAttrs
                  (_: flake: {inherit flake;})
                  sansNixpkgs;
                package = nix.packages.nix;
                settings.flake-registry = "${registry}/flake-registry.json";
              };
            }
          ];
        };
    });
}
