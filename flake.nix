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

    qnixpkgs.url = "github:Samayel/qnixpkgs";
    qnixpkgs.inputs.nixpkgs.follows = "nixpkgs";
    qnixpkgs.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    qnixpkgs.inputs.flake-utils.follows = "flake-utils";
    qnixpkgs.inputs.devshell.follows = "devshell";
    qnixpkgs.inputs.flake-compat.follows = "flake-compat";
    qnixpkgs.inputs.qnixpkgs.follows = "qnixpkgs";
    qnixpkgs.inputs.shellscripts.follows = "shellscripts";
    qnixpkgs.inputs.mersenneforumorg.follows = "mersenneforumorg";

    shellscripts.url = "github:Samayel/shellscripts.nix";
    shellscripts.inputs.nixpkgs.follows = "nixpkgs";
    shellscripts.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    shellscripts.inputs.flake-utils.follows = "flake-utils";
    shellscripts.inputs.devshell.follows = "devshell";
    shellscripts.inputs.flake-compat.follows = "flake-compat";
    shellscripts.inputs.qnixpkgs.follows = "qnixpkgs";

    mersenneforumorg.url = "github:Samayel/mersenneforumorg.nix";
    mersenneforumorg.inputs.nixpkgs.follows = "nixpkgs";
    mersenneforumorg.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    mersenneforumorg.inputs.flake-utils.follows = "flake-utils";
    mersenneforumorg.inputs.devshell.follows = "devshell";
    mersenneforumorg.inputs.flake-compat.follows = "flake-compat";
    mersenneforumorg.inputs.qnixpkgs.follows = "qnixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, shellscripts, mersenneforumorg, ... }:
    let
      version = builtins.substring 0 8 self.lastModifiedDate;
    in
    {
      overlays = {
        cas = import cas/overlay.nix version;
        duply = import duply/overlay.nix;
        linac = import linac/overlay.nix;
        qshell = import qshell/overlay.nix version;
      };
    }
    //
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (system:
      let

        flakeOverlays = builtins.concatMap builtins.attrValues [
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

        flakePkgsNoExternal = builtins.attrNames
          {
            inherit (self.packages.${system})
              default
              ci-build
              ci-publish
              docker;
          };

        flakePkgs =
          {
            inherit (pkgs)
              duply
              linac
              qshell-minimal
              qshell-standard
              qshell-full
              qshell;

            inherit (pkgs.unstable)
              cas;
          }
          //
          (removeAttrs shellscripts.packages.${system} flakePkgsNoExternal)
          //
          (removeAttrs mersenneforumorg.packages.${system} flakePkgsNoExternal);

        flakePkgsNoDefault = builtins.attrNames
          {
          };

        flakePkgsNoBuild = builtins.attrNames
          {
          }
          ++
          flakePkgsNoDefault;

        flakePkgsNoPublish = builtins.attrNames
          {
            inherit (flakePkgs)
              cas;
          }
          ++
          flakePkgsNoDefault;

        callPackage = path: overrides:
          let f = import path;
          in f ((builtins.intersectAttrs (builtins.functionArgs f) (pkgs // flakePkgs)) // overrides);

      in {

        packages =
          let
            inherit (builtins) all attrNames filter;
            inherit (pkgs) linkFarmFromDrvs;
            mapfilterFlakePkgs = exclude: map (x: flakePkgs.${x}) (filter (x: all (y: x != y) exclude) (attrNames flakePkgs));
          in
            flakePkgs
            //
            {
              default = linkFarmFromDrvs "qnixpkgs-packages-default" (mapfilterFlakePkgs flakePkgsNoDefault);

              ci-build = linkFarmFromDrvs "qnixpkgs-packages-ci-build" (mapfilterFlakePkgs flakePkgsNoBuild);
              ci-publish = linkFarmFromDrvs "qnixpkgs-packages-ci-publish" (mapfilterFlakePkgs flakePkgsNoPublish);

              docker = (callPackage ./docker.nix { }).overrideAttrs (oldAttrs: { name = "qnixpkgs-packages-docker"; });
            };

        apps = removeAttrs
          (
            (callPackage ./apps.nix { })
            //
            shellscripts.apps.${system}
            //
            mersenneforumorg.apps.${system}
          )
          [ "default" ];

      }
    );

}
