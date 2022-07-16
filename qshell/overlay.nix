final: prev:

{

  qshell = prev.symlinkJoin
  {
    name = "qshell";
    preferLocalBuild = false;
    allowSubstitutes = true;

    paths = with prev; [
      bashInteractive
      coreutils
      gawk-with-extensions
      gnugrep
      gnused
      gnutar
      gzip
      joe
      less
      mc
      moreutils
      nano
      screen
      which
    ];
  };

}
