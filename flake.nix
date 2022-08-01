{
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs.url = "github:nixos/nixpkgs/d4f600ec45d9a14d41a4d5a61c034fa1bd819f88";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/f4a4245e55660d0a590c17bab40ed08a1d010787";

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
      version =
        let
          inherit (builtins) substring;
          inherit (self) lastModifiedDate;
        in
        "0.${substring 0 8 lastModifiedDate}.${substring 8 6 lastModifiedDate}.${self.shortRev or "dirty"}";
    in
    {
      overlays = {
        axonsh = import axon.sh/overlay.nix;
        cas = import cas/overlay.nix version;
        cronic = import cronic/overlay.nix;
        danecheck = import danecheck/overlay.nix;
        dotfiles = import dotfiles/overlay.nix version;
        duply = import duply/overlay.nix;
        kakoune = import kakoune/overlay.nix;
        linac = import linac/overlay.nix;
        qshell = import qshell/overlay.nix version;
        userprofile-stable = import userprofile-stable/overlay.nix version;
        userprofile-unstable = import userprofile-unstable/overlay.nix version;
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
              axonsh
              cronic
              danecheck
              danecheck-cronic
              dotfiles
              duply
              duply-cronic
              kakoune
              linac
              qshell-minimal
              qshell-standard
              qshell-full
              qshell;

            inherit (pkgs.unstable)
              cas;

            userprofile = pkgs.buildEnv
              {
                name = "userprofile-global-${version}";
                paths = [
                  pkgs.userprofile-stable
                  pkgs.unstable.userprofile-unstable
                ];
              };
          }
          //
          (removeAttrs shellscripts.packages.${system} flakePkgsNoExternal)
          //
          (removeAttrs mersenneforumorg.packages.${system} flakePkgsNoExternal);

        flakePkgsNoDefault = builtins.attrNames
          {
            inherit (flakePkgs)
              cas
              danecheck
              danecheck-cronic;
          };

        flakePkgsNoCIBuild = flakePkgsNoDefault ++ builtins.attrNames
          { };

        flakePkgsNoCIPublish = flakePkgsNoCIBuild ++ builtins.attrNames
          { };

        callPackage = pkgs.lib.callPackageWith (pkgs // flakePkgs);
        callPackageNonOverridable = fn: args: removeAttrs (callPackage fn args) [ "override" "overrideDerivation" ];
      in
      {
        packages =
          let
            inherit (builtins) all attrNames filter;
            inherit (pkgs) linkFarmFromDrvs;
            mapfilterFlakePkgs = exclude: map (x: flakePkgs.${x}) (filter (x: all (y: x != y) exclude) (attrNames flakePkgs));
          in
          flakePkgs
          //
          {
            default = linkFarmFromDrvs "qnixpkgs-default-${version}" (mapfilterFlakePkgs flakePkgsNoDefault);

            ci-build = linkFarmFromDrvs "qnixpkgs-ci-build-${version}" (mapfilterFlakePkgs flakePkgsNoCIBuild);
            ci-publish = linkFarmFromDrvs "qnixpkgs-ci-publish-${version}" (mapfilterFlakePkgs flakePkgsNoCIPublish);

            docker = (callPackage ./docker.nix { }).overrideAttrs (oldAttrs: { name = "qnixpkgs-docker-${version}"; });
          };

        apps = removeAttrs
          (
            (callPackageNonOverridable ./apps.nix { })
            //
            shellscripts.apps.${system}
            //
            mersenneforumorg.apps.${system}
          )
          [ "default" ];

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
