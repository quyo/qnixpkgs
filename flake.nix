{
  inputs = {
    # nixpkgs-stable.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs-stable.url = "github:nixos/nixpkgs/d4f600ec45d9a14d41a4d5a61c034fa1bd819f88";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/f4a4245e55660d0a590c17bab40ed08a1d010787";

    flake-utils.url = "github:numtide/flake-utils";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs-stable";
    devshell.inputs.flake-utils.follows = "flake-utils";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    qnixpkgs.url = "github:Samayel/qnixpkgs";
    qnixpkgs.inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    qnixpkgs.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    qnixpkgs.inputs.flake-utils.follows = "flake-utils";
    qnixpkgs.inputs.devshell.follows = "devshell";
    qnixpkgs.inputs.flake-compat.follows = "flake-compat";
    qnixpkgs.inputs.qnixpkgs.follows = "qnixpkgs";
    qnixpkgs.inputs.shellscripts.follows = "shellscripts";
    qnixpkgs.inputs.mersenneforumorg.follows = "mersenneforumorg";

    shellscripts.url = "github:Samayel/shellscripts.nix";
    shellscripts.inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    shellscripts.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    shellscripts.inputs.flake-utils.follows = "flake-utils";
    shellscripts.inputs.devshell.follows = "devshell";
    shellscripts.inputs.flake-compat.follows = "flake-compat";
    shellscripts.inputs.qnixpkgs.follows = "qnixpkgs";

    mersenneforumorg.url = "github:Samayel/mersenneforumorg.nix";
    mersenneforumorg.inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    mersenneforumorg.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    mersenneforumorg.inputs.flake-utils.follows = "flake-utils";
    mersenneforumorg.inputs.devshell.follows = "devshell";
    mersenneforumorg.inputs.flake-compat.follows = "flake-compat";
    mersenneforumorg.inputs.qnixpkgs.follows = "qnixpkgs";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, flake-utils, shellscripts, mersenneforumorg, ... }:
    {
      overlays = {
        axonsh = import axon.sh/overlay.nix self;
        bat-extras = import bat-extras/overlay.nix self;
        cas = import cas/overlay.nix self;
        cronic = import cronic/overlay.nix self;
        danecheck = import danecheck/overlay.nix self;
        dotfiles = import dotfiles/overlay.nix self;
        duply = import duply/overlay.nix self;
        iconv = import iconv/overlay.nix self;
        kakoune = import kakoune/overlay.nix self;
        lib = import lib/overlay.nix self;
        linac = import linac/overlay.nix self;
        qshell = import qshell/overlay.nix self;
        userprofile-stable = import userprofile-stable/overlay.nix self;
        userprofile-unstable = import userprofile-unstable/overlay.nix self;
      };
    }
    //
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (system:
      let
        inherit (pkgs-stable) buildEnv lib;

        version = lib.q.flake.version self;

        overlays = builtins.concatMap builtins.attrValues [
          self.overlays
          shellscripts.overlays
          mersenneforumorg.overlays
        ];

        pkgs-stable = import nixpkgs-stable { inherit overlays system; };
        pkgs-unstable = import nixpkgs-unstable { inherit overlays system; };

        flake-pkgs-mapper = lib.q.mapPkgs
          [
            "axonsh"
            "batdiff"
            "batgrep"
            "batman"
            "batpipe"
            "batwatch"
            "cas"
            "cronic"
            "danecheck"
            "danecheck-cronic"
            "dotfiles"
            "duply"
            "duply-cronic"
            "kakoune"
            "linac"
            "prettybat"
            "qshell-minimal"
            "qshell-standard"
            "qshell-full"
            "qshell"
          ];

        flake-pkgs =
          flake-pkgs-mapper pkgs-stable "" ""
          //
          flake-pkgs-mapper pkgs-unstable "" "-unstable"
          //
          {
            userprofile = buildEnv
              {
                name = "userprofile-global-${version}";
                paths = [
                  pkgs-stable.userprofile-stable
                  pkgs-unstable.userprofile-unstable
                ];
              };
          }
          //
          (removeAttrs shellscripts.packages.${system} exclusions.from-external)
          //
          (removeAttrs mersenneforumorg.packages.${system} exclusions.from-external);

        exclusions = rec
        {
          from-external = builtins.attrNames
            {
              inherit (self.packages.${system})
                default
                ci-build
                ci-publish
                docker;
            };

          from-default = builtins.attrNames
            (
              flake-pkgs-mapper pkgs-unstable "" "-unstable"
              //
              {
                inherit (flake-pkgs)
                  cas
                  danecheck
                  danecheck-cronic;
              }
            );

          from-ci-build = from-default ++ builtins.attrNames
            { };

          from-ci-publish = from-ci-build ++ builtins.attrNames
            { };
        };
      in
      {
        packages = lib.q.flake.packages "qnixpkgs" version flake-pkgs exclusions ./docker.nix;

        apps = removeAttrs
          (
            lib.q.flake.apps flake-pkgs ./apps.nix
            //
            shellscripts.apps.${system}
            //
            mersenneforumorg.apps.${system}
          )
          [ "default" ];

        formatter = lib.q.flake.formatter;
      }
    );
}
