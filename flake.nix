{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.inputs.flake-utils.follows = "flake-utils";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    shellscripts.url = "github:Samayel/shellscripts.nix";
    shellscripts.inputs.nixpkgs.follows = "nixpkgs";
    shellscripts.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    shellscripts.inputs.flake-utils.follows = "flake-utils";
    shellscripts.inputs.devshell.follows = "devshell";
    shellscripts.inputs.flake-compat.follows = "flake-compat";

    mersenneforumorg.url = "github:Samayel/mersenneforumorg.nix";
    mersenneforumorg.inputs.nixpkgs.follows = "nixpkgs";
    mersenneforumorg.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    mersenneforumorg.inputs.flake-utils.follows = "flake-utils";
    mersenneforumorg.inputs.devshell.follows = "devshell";
    mersenneforumorg.inputs.flake-compat.follows = "flake-compat";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, shellscripts, mersenneforumorg, ... }:
    {
      overlays = {
        cas = import cas/overlay.nix;
        duply = import duply/overlay.nix;
        qshell = import qshell/overlay.nix;
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
            inherit (pkgs)
              duply
              qshell-minimal
              qshell-standard
              qshell-full
              qshell;

            inherit (pkgs.unstable)
              cas;
          }
          //
          shellscripts.packages.${system}
          //
          mersenneforumorg.packages.${system};

        flakePkgsNoDefault = builtins.attrNames
          {
            inherit (flakePkgs)
              qshell-minimal
              qshell-standard
              qshell;
          };

        flakePkgsNoPublish = builtins.attrNames
          {
            inherit (flakePkgs)
              cas;
          }
          ++
          flakePkgsNoDefault;

      in {

        packages = flakePkgs
          //
          {
            default = with builtins; pkgs.linkFarmFromDrvs "qnixpkgs-packages-all" (map (x: flakePkgs.${x}) (filter (x: all (y: x != y) flakePkgsNoDefault) (attrNames flakePkgs)));

            ci-build = self.packages.${system}.default;
            ci-publish = with builtins; pkgs.linkFarmFromDrvs "qnixpkgs-packages-ci-publish" (map (x: flakePkgs.${x}) (filter (x: all (y: x != y) flakePkgsNoPublish) (attrNames flakePkgs)));

            docker = import ./docker.nix pkgs;
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
