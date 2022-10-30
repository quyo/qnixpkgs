{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs-stable";
    devshell.inputs.flake-utils.follows = "flake-utils";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, flake-utils, devshell, ... }:
    {
      overlays = {
        default = import ./overlay.nix self;
      };
    }
    //
    flake-utils.lib.eachSystem (map (x: flake-utils.lib.system.${x}) [ "x86_64-linux" ]) (system:
      let
        overlays = (builtins.attrValues self.overlays) ++ [
          devshell.overlay
        ];

        pkgs-stable = import nixpkgs-stable { inherit overlays system; };
        pkgs-unstable = import nixpkgs-unstable { inherit overlays system; };
      in
      {
        packages = rec {
          my-project = pkgs-stable.my-project;
          my-project-devenv = pkgs-stable.my-project-devenv;
          default = my-project;
        };

        apps = rec {
          my-project = { type = "app"; program = "${pkgs-stable.my-project}/bin/hello"; };
          default = my-project;
        };

        devShells = {
          default =
            let
              inherit (pkgs-stable.devshell) mkShell importTOML;
            in
            mkShell {
              imports = [ (importTOML ./devshell.toml) ];
            };
        };

        formatter = pkgs-stable.nixpkgs-fmt;
      }
    );
}
