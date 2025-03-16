{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import ./flake-overlay.nix) ];
        pkgs = import nixpkgs { inherit overlays system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            fortune
            cowsay
            lolcat
            # pythonEnv
          ];

          shellHook = ''
            fortune | LANG=C cowsay | lolcat
          '';
        };
      }
    );
}
