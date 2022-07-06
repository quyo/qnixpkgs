{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
    flake-utils.url = "github:numtide/flake-utils";

    shellscripts.url = "github:Samayel/shellscripts.nix";
    shellscripts.inputs.nixpkgs.follows = "nixpkgs";

    mersenneforumorg.url = "github:Samayel/mersenneforumorg.nix";
    mersenneforumorg.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, shellscripts, mersenneforumorg }:
    flake-utils.lib.simpleFlake {
      inherit self nixpkgs;
      name = "qnixpkgs-flake";
      config = { };
      overlay = import ./overlay.nix (
        shellscripts.legacyPackages.x86_64-linux //
        mersenneforumorg.legacyPackages.x86_64-linux
      );
      systems = [ "x86_64-linux" ];
    } // {
      packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.hello;
    };

}
