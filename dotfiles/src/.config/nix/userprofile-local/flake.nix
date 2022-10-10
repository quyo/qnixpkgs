{

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    qnixpkgs.url = "github:Samayel/qnixpkgs";
    qnixpkgs.inputs.qnixpkgs.follows = "qnixpkgs";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, flake-utils, qnixpkgs, ... }:
    let
      inherit (builtins) attrNames concatMap getAttr substring;
      inherit (nixpkgs-stable.lib) attrByPath importJSON;
      inherit (self) lastModifiedDate;

      version = "0.${substring 0 8 lastModifiedDate}.${substring 8 6 lastModifiedDate}.${self.shortRev or "dirty"}";

      json = importJSON ./packages.json;

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
      inherit nixpkgs-stable nixpkgs-unstable qnixpkgs;
    }
    //
    flake-utils.lib.eachSystem (map (x: flake-utils.lib.system.${x}) [ "x86_64-linux" "armv7l-linux" ]) (system:
      let
        inherit (nixpkgs-stable.outputs.legacyPackages.${system}) buildEnv;
      in
      {
        packages.default = buildEnv
          {
            name = "userprofile-local-${version}";
            paths = getAllPkgs system;
          };
      }
    );

}
