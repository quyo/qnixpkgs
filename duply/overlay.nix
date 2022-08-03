self: final: prev:

let
  inherit (final) writeShellScriptBin;
in

{
  duplicity = prev.duplicity.overrideAttrs (oldAttrs: {
    pythonPath = (oldAttrs.pythonPath or [ ]) ++ [ final.python3.pkgs.boto ];
  });

  duply = prev.duply.override { duplicity = final.duplicity; };

  duply-cronic = (writeShellScriptBin "duply-cronic"
    ''
      CRONIC_IGNORE='
      ^\/nix\/store\/[a-z0-9.-]*\/bin\/\.duply-wrapped: line [0-9]*: WARNING:: command not found$
      ' exec -a "$0" ${final.cronic}/bin/cronic ${final.duply}/bin/duply "$@"
    '').overrideAttrs (oldAttrs:
    let
      version = "${final.duply.version}+${final.cronic.version}";
    in
    {
      name = "duply-cronic-${version}";
      inherit version;
    });
}
