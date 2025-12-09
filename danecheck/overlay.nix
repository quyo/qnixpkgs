self: final: prev:

let
  system = prev.stdenv.hostPlatform.system;

  wrapper = final.writeShellScriptBin "danecheck-cronic"
    ''
      exec -a "$0" ${final.cronic}/bin/cronic ${final.danecheck}/bin/danecheck "$@"
    '';
in

{
  danecheck = final.callPackage ./. { inherit system; };

  danecheck-cronic = final.lib.q.overrideName wrapper "danecheck-cronic" "${final.danecheck.version}+${final.cronic.version}";
}
