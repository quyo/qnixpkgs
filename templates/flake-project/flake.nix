{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs-stable";
    devshell.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, flake-utils, devshell, ... }:
    let
      inherit (builtins) attrNames concatMap getAttr substring;
      inherit (nixpkgs-stable.lib) attrByPath importJSON;
      inherit (self) lastModifiedDate;

      version = "0.${substring 0 8 lastModifiedDate}.${substring 8 6 lastModifiedDate}.${self.shortRev or "dirty"}";

      json = importJSON ./devenv-packages.json;

      getFlakePkgs = system: label:
        let
          outs = (getAttr label self).outputs;
          pkgs = (attrByPath [ "legacyPackages" system ] { } outs) // (attrByPath [ "packages" system ] { } outs);
        in
        map
          (x: getAttr x pkgs)
          (getAttr label json);

      getAllPkgs = system: concatMap (getFlakePkgs system) (attrNames json);
    in
    {
      # needed by (getAttr label self) in getFlakePkgs
      inherit nixpkgs-stable nixpkgs-unstable self;

      overlays = {
        default = import ./overlay.nix self;
      };
    }
    //
    flake-utils.lib.eachSystem (map (x: flake-utils.lib.system.${x}) [ "x86_64-linux" ]) (system:
      let
        overlays = (builtins.attrValues self.overlays) ++ [
          devshell.overlay
        ];

        pkgs-stable = import nixpkgs-stable { inherit overlays system; };
        pkgs-unstable = import nixpkgs-unstable { inherit overlays system; };
      in
      {
        packages = rec {
          my-project = pkgs-stable.my-project;
          my-project-devenv = pkgs-stable.buildEnv
            {
              name = "my-project-devenv-${version}";
              paths = getAllPkgs system;
            };
          default = my-project;
        };

        apps = rec {
          my-project = { type = "app"; program = "${pkgs-stable.my-project}/bin/hello"; };
          default = my-project;
        };

        devShells = {
          default =
            let
              inherit (pkgs-stable.devshell) mkShell importTOML;
            in
            mkShell {
              imports = [ (importTOML ./devshell.toml) ];
            };
        };

        formatter = pkgs-stable.nixpkgs-fmt;
      }
    );
}
