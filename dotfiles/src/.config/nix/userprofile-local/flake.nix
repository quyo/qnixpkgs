{

  inputs = {
    # nixpkgs-stable.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs-stable.url = "github:nixos/nixpkgs/a28adc36c20fd2fbaeb06ec9bbd79b6bf7443979";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/0e304ff0d9db453a4b230e9386418fd974d5804a";

    flake-utils.url = "github:numtide/flake-utils";

    qnixpkgs.url = "github:Samayel/qnixpkgs";
    qnixpkgs.inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    qnixpkgs.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    qnixpkgs.inputs.flake-utils.follows = "flake-utils";
    qnixpkgs.inputs.qnixpkgs.follows = "qnixpkgs";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, flake-utils, qnixpkgs, ... }:
    let
      version =
        let
          inherit (builtins) substring;
          inherit (self) lastModifiedDate;
        in
        "0.${substring 0 8 lastModifiedDate}.${substring 8 6 lastModifiedDate}.${self.shortRev or "dirty"}";

      json = nixpkgs-stable.lib.importJSON ./packages.json;

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
      inherit nixpkgs-stable nixpkgs-unstable qnixpkgs;
    }
    //
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux flake-utils.lib.system.armv7l-linux ] (system:
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
