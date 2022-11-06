{
  # nixConfig.extra-substituters = "https://quyo-public.cachix.org ssh://eu.nixbuild.net?priority=90";
  # nixConfig.extra-trusted-public-keys = "quyo-public.cachix.org-1:W83ifK7/6EvKU4Q2ZxvHRAkiIRzPeXYnp9LWHezs5U0= nixbuild.net/quyo-1:TaAsUc6SBQnXhUQJM4s+1oQlTKa1e3M0u3Zqb36fbRc=";

  inputs = {
    # nixpkgs-stable.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs-stable.url = "github:nixos/nixpkgs/9ecc270f02b09b2f6a76b98488554dd842797357";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/95fda953f6db2e9496d2682c4fc7b82f959878f7";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    flake-utils.url = "github:numtide/flake-utils";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs-stable";
    devshell.inputs.flake-utils.follows = "flake-utils";

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
        fzf-git = import fzf-git/overlay.nix self;
        iconv = import iconv/overlay.nix self;
        kakoune = import kakoune/overlay.nix self;
        linac = import linac/overlay.nix self;
        qfixes = import qfixes/overlay.nix self;
        qlib = import qlib/overlay.nix self;
        qshell = import qshell/overlay.nix self;
        userprofile = import userprofile/overlay.nix self;
      };

      templates = rec {
        flake-project = {
          description = "A flake project template, usage: nix flake new -t github:Samayel/qnixpkgs#flake-project .)";
          path = ./templates/flake-project;
        };
        node-nest-project = {
          description = "A node + nest + typescript project template, usage: nix flake new -t github:Samayel/qnixpkgs#node-nest-project .)";
          path = ./templates/node-nest-project;
        };
        default = flake-project;
      };
    }
    //
    flake-utils.lib.eachSystem (map (x: flake-utils.lib.system.${x}) [ "x86_64-linux" "armv7l-linux" ]) (system:
      let
        inherit (pkgs-stable) buildEnv lib;

        version = lib.q.flake.version self;

        overlays = builtins.concatMap builtins.attrValues
          ([
            self.overlays
            shellscripts.overlays
            mersenneforumorg.overlays
          ]
          ++
          nixpkgs-stable.lib.optionals (system != flake-utils.lib.system.armv7l-linux)
            [
            ]);

        pkgs-stable = import nixpkgs-stable { inherit overlays system; };
        pkgs-unstable = import nixpkgs-unstable { inherit overlays system; };

        flake-pkgs-mapper = lib.q.mapPkgs
          ([
            "axonsh"
            "batdiff"
            "batgrep"
            "batman"
            "batpipe"
            "batwatch"
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
          ]
          ++
          lib.optionals (system != flake-utils.lib.system.armv7l-linux)
            [
              "cas"
            ]);

        flake-pkgs = removeAttrs
          (
            flake-pkgs-mapper pkgs-stable "" ""
            //
            lib.optionalAttrs (system != flake-utils.lib.system.armv7l-linux) (flake-pkgs-mapper pkgs-unstable "" "-unstable")
            //
            {
              userprofile = buildEnv
                {
                  name = "userprofile-global-${version}";
                  paths = [
                    pkgs-stable.userprofile.stable
                    pkgs-unstable.userprofile.unstable
                  ];
                };
            }
            //
            shellscripts.packages.${system}
            //
            lib.optionalAttrs (system != flake-utils.lib.system.armv7l-linux) mersenneforumorg.packages.${system}
          )
          exclusions.from-internal;

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

          from-internal = from-external ++
          [
            "batwatch-unstable"
            "qshell-full-unstable"
          ];

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

        legacyPackages = pkgs-stable;

        apps = removeAttrs
          (
            lib.q.flake.apps flake-pkgs ./apps.nix
            //
            shellscripts.apps.${system}
            //
            lib.optionalAttrs (system != flake-utils.lib.system.armv7l-linux) mersenneforumorg.apps.${system}
          )
          [ "default" ];

        formatter = lib.q.flake.formatter;
      }
    );
}
