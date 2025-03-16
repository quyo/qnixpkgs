{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    flake-utils.url = "github:numtide/flake-utils";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, devshell, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import ./flake-overlay.nix) devshell.overlays.default ];
        pkgs = import nixpkgs { inherit overlays system; };
      in
      {
        # packages = rec {
        #   default = pythonEnv;
        #   inherit (pkgs) pythonEnv;
        # };

        devShells = rec {
          default = myshell;
          myshell =
            let
              inherit (pkgs.devshell) mkShell importTOML;
            in
            mkShell {
              imports = [ (importTOML ./flake-shell.toml) ];
            };
        };
      }
    );
}
