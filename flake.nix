{
  description = "Flake for Project Horus Telemetry Decoder GUI (horus-gui)";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          pythonEnv = pkgs.python313.withPackages (ps: [
            #ps.numpy
          ]);
        in
        {
          packages.horusdemodlib = pythonEnv.pkgs.callPackage ./horusdemodlib.nix { };
          packages.horus-gui = pythonEnv.pkgs.callPackage ./horus-gui.nix { horusdemodlib = self'.packages.horusdemodlib; };
          packages.default = self'.packages.horus-gui;
        };
    };
}
