{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
    flake-utils.url = "github:numtide/flake-utils";
    mersenneforumorg.url = "github:Samayel/mersenneforumorg.nix";
  };

  outputs = { self, nixpkgs, flake-utils, mersenneforumorg }:
    flake-utils.lib.simpleFlake {
      inherit self nixpkgs;
      name = "qnixpkgs-flake";
      config = { };
      overlay = import ./overlay.nix (
        mersenneforumorg.legacyPackages.x86_64-linux //
        { }
      );
      systems = [ "x86_64-linux" ];
    };

}
