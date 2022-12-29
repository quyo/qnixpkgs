system: self: final: prev:

let
  buildenv = file: name:
    let
      inherit (builtins) attrNames concatMap getAttr;
      inherit (final) buildEnv;
      inherit (final.lib) attrByPath getAttrFromPath importJSON splitString;

      json = importJSON file;

      getFlakePkgs = system: label:
        let
          outs = (getAttr label self).outputs;
          pkgs = (attrByPath [ "legacyPackages" system ] { } outs) // (attrByPath [ "packages" system ] { } outs);
        in
        map
          (x: getAttrFromPath (splitString "." x) pkgs)
          (getAttr label json);

      getAllPkgs = system: concatMap (getFlakePkgs system) (attrNames json);
    in
    buildEnv
      {
        inherit name;
        paths = getAllPkgs system;
      };
in

{
  flake-devenv = buildenv ./flake-packages-devenv.json "flake-devenv";
  flake-runtime = buildenv ./flake-packages-runtime.json "flake-runtime";
}
