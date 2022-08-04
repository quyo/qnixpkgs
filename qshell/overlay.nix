self: final: prev:

let
  version = final.lib.q.flake.version self;

  qshell-base = final.buildEnv { name = "qshell-base"; paths = [ ]; };
in

with final; {
  qshell-minimal = lib.q.extendEnv qshell-base "qshell-minimal" version [
    bashInteractive
    coreutils-full
    less
    nano
  ];

  qshell-standard = lib.q.extendEnv qshell-minimal "qshell-standard" version [
    findutils
    gawk
    gnugrep
    gnused
    gnutar
    gzip
    which
  ];

  qshell-full = lib.q.extendEnv qshell-standard "qshell-full" version [
    gawk-with-extensions
    joe
    mc
    moreutils
    screen
  ];

  qshell = lib.q.overrideName qshell-standard "qshell" version;
}
