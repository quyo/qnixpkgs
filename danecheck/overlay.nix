final: prev:

let
  inherit (final) writeShellScriptBin;
in

{
  danecheck = final.callPackage ./. { };

  danecheck-cronic = (writeShellScriptBin "danecheck-cronic"
    ''
      exec -a "$0" ${final.cronic}/bin/cronic ${final.danecheck}/bin/danecheck "$@"
    '').overrideAttrs (oldAttrs:
    let
      version = "${final.danecheck.version}+${final.cronic.version}";
    in
    {
      name = "danecheck-cronic-${version}";
      inherit version;
    });
}
