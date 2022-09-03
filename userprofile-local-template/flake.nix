{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    qnixpkgs.url = "github:Samayel/qnixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, qnixpkgs, ... }:
    let
      version =
        let
          inherit (builtins) substring;
          inherit (self) lastModifiedDate;
        in
        "0.${substring 0 8 lastModifiedDate}.${substring 8 6 lastModifiedDate}.${self.shortRev or "dirty"}";

      json = nixpkgs.lib.importJSON ./packages.json;

      getFlakePkgs = system: label:
        let
          inherit (builtins) getAttr;

          outs = (getAttr label self).outputs;
          pkgs = (outs.packages or outs.legacyPackages).${system};
        in
        map
          (x: getAttr x pkgs)
          (getAttr label json);

      getAllPkgs = system:
        let inherit (builtins) attrNames concatMap;
        in concatMap (getFlakePkgs system) (attrNames json);
    in
    {
      # needed by (getAttr label self) in getFlakePkgs
      inherit nixpkgs nixpkgs-unstable qnixpkgs;
    }
    //
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux flake-utils.lib.system.armv7l-linux ] (system:
      let
        inherit (nixpkgs.outputs.legacyPackages.${system}) buildEnv;
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
