self: final: prev:

let
  version = final.lib.q.flakeVersion self;
in

{
  qshell-minimal = final.buildEnv
    {
      name = "qshell-minimal-${version}";
      paths = with final; [
        bashInteractive
        coreutils-full
        less
        nano
      ];
    };

  qshell-standard = final.qshell-minimal.overrideAttrs (oldAttrs: {
    name = "qshell-standard-${version}";
    paths = with final; (oldAttrs.paths or [ ]) ++ [
      findutils
      gawk
      gnugrep
      gnused
      gnutar
      gzip
      which
    ];
  });

  qshell-full = final.qshell-standard.overrideAttrs (oldAttrs: {
    name = "qshell-full-${version}";
    paths = with final; (oldAttrs.paths or [ ]) ++ [
      gawk-with-extensions
      joe
      mc
      moreutils
      screen
    ];
  });

  qshell = final.qshell-standard.overrideAttrs (oldAttrs: { name = "qshell-${version}"; });
}
