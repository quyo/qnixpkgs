self: final: prev:

let
  inherit (builtins) all attrNames filter substring;

  qlib = {
    flakeVersion = flake:
      "0.${substring 0 8 flake.lastModifiedDate}.${substring 8 6 flake.lastModifiedDate}.${flake.shortRev or "dirty"}";

    removeListAttrs = list: exclude: map (x: list.${x}) (filter (x: all (y: x != y) exclude) (attrNames list));

    removeOverrideFuncs = set: removeAttrs set [ "override" "overrideDerivation" ];
  };
in

{
  lib = prev.lib // {
    q = qlib;
  };
}
