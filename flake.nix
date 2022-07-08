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
    {
      overlays = {
        duply = import duply/overlay.nix;
      };
    }
    //
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (system:
      let

        pkgs = import nixpkgs {
          inherit system;
          overlays = with builtins; concatMap attrValues [
            self.overlays
            shellscripts.overlays
            mersenneforumorg.overlays
          ];
        };

        flakePkgs =
          {
            inherit (pkgs) duply;
          }
          //
          shellscripts.packages.${system}
          //
          mersenneforumorg.packages.${system};

      in {

        packages = flakePkgs
          //
          {
            default = pkgs.hello.overrideAttrs (oldAttrs: {
              nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ map (x: flakePkgs.${x}) (builtins.attrNames flakePkgs);
            });
          };

      }
    );

}
