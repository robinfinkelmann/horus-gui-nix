{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import an internal flake module: ./other.nix
        # To import an external flake module:
        #   1. Add foo to inputs
        #   2. Add foo as a parameter to the outputs function
        #   3. Add here: foo.flakeModule

      ];
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

          devShells.default =
            pkgs.mkShell {
              packages = [
                pythonEnv
              ];
            };
        };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
