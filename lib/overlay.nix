self: final: prev:

let
  inherit (builtins) all attrNames filter substring;

  qlib = {

    extendEnv = baseEnv: pname: version: paths: baseEnv.overrideAttrs (oldAttrs: {
      inherit pname version;
      name = "${pname}-${version}";
      paths = (oldAttrs.paths or [ ]) ++ paths;
    });

    flakeVersion = flake:
      "0.${substring 0 8 flake.lastModifiedDate}.${substring 8 6 flake.lastModifiedDate}.${flake.shortRev or "dirty"}";

    overrideName = set: pname: version: set.overrideAttrs (oldAttrs: {
      inherit pname version;
      name = "${pname}-${version}";
    });

    removeListAttrs = list: exclude: map (x: list.${x}) (filter (x: all (y: x != y) exclude) (attrNames list));

    removeOverrideFuncs = set: removeAttrs set [ "override" "overrideDerivation" ];

  };
in

{
  lib = prev.lib // {
    q = qlib;
  };
}
