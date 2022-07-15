{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.inputs.flake-utils.follows = "flake-utils";

    shellscripts.url = "github:Samayel/shellscripts.nix";
    shellscripts.inputs.nixpkgs.follows = "nixpkgs";
    shellscripts.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    shellscripts.inputs.flake-utils.follows = "flake-utils";
    shellscripts.inputs.devshell.follows = "devshell";

    mersenneforumorg.url = "github:Samayel/mersenneforumorg.nix";
    mersenneforumorg.inputs.nixpkgs.follows = "nixpkgs";
    mersenneforumorg.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    mersenneforumorg.inputs.flake-utils.follows = "flake-utils";
    mersenneforumorg.inputs.devshell.follows = "devshell";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, shellscripts, mersenneforumorg }:
    {
      overlays = {
        duply = import duply/overlay.nix;
      };
    }
    //
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (system:
      let

        flakeOverlays = with builtins; concatMap attrValues [
          self.overlays
          shellscripts.overlays
          mersenneforumorg.overlays
        ];

        # can now use "pkgs.package" or "pkgs.unstable.package"
        unstableOverlay = final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            overlays = flakeOverlays;
          };
        };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ unstableOverlay ] ++ flakeOverlays;
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
            default = pkgs.linkFarmFromDrvs "qnixpkgs-packages-all" (map (x: flakePkgs.${x}) (builtins.attrNames flakePkgs));
          };

        apps = removeAttrs
          (
            (import ./apps.nix self system)
            //
            shellscripts.apps.${system}
            //
            mersenneforumorg.apps.${system}
          )
          [ "default" ];

      }
    );

}
