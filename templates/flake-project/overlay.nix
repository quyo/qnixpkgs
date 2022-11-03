system: self: final: prev:

let
  devenv = file: name:
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
  my-project = final.hello;
  my-project-devenv = devenv ./devenv-packages.json "my-project-devenv";
}
