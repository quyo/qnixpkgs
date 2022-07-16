final: prev:

{

  qshell-minimal = prev.symlinkJoin
  {
    name = "qshell-minimal";
    preferLocalBuild = false;
    allowSubstitutes = true;

    paths = with prev; [
      bashInteractive
      coreutils
      less
      nano
    ];
  };

  qshell-standard = final.qshell-minimal.overrideAttrs (oldAttrs: {
    name = "qshell-standard";
    paths = with prev; (oldAttrs.paths or []) ++ [
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
    name = "qshell-full";
    paths = with prev; (oldAttrs.paths or []) ++ [
      gawk-with-extensions
      joe
      mc
      moreutils
      screen
    ];
  });

  qshell = final.qshell-standard;

}
