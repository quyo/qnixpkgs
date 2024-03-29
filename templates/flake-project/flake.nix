{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs-stable";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, flake-utils, devshell, ... }:
    {
      # needed by (getAttr label self) in getFlakePkgs
      inherit nixpkgs-stable nixpkgs-unstable self;
    }
    //
    flake-utils.lib.eachSystem (map (x: flake-utils.lib.system.${x}) [ "x86_64-linux" ]) (system:
      let
        overlays = [
          (import ./flake-overlay.nix system self)
          devshell.overlays.default
        ];

        pkgs = import nixpkgs-stable { inherit overlays system; };
      in
      {
        packages = rec {
          default = flake-devenv;
          inherit (pkgs) flake-devenv flake-runtime;
        };

        apps = rec {
          default = flake-app;
          flake-app = { type = "app"; program = "${pkgs.hello}/bin/hello"; };
        };

        devShells = rec {
          default = flake-devshell;
          flake-devshell =
            let
              inherit (pkgs.devshell) mkShell importTOML;
            in
            mkShell {
              imports = [ (importTOML ./flake-devshell.toml) ];
            };
        };

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
