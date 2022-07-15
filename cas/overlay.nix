final: prev:

let
  py3 = prev.python3.withPackages (p: with p; [ gmpy2 mpmath ]);
in

{

  cas = prev.symlinkJoin
  {
    name = "cas";
    preferLocalBuild = false;
    allowSubstitutes = true;

    paths = with final; [
      maxima
      octave
      pari
      pari-galdata
      pari-seadata-small
      py3
      sagetex
      sageWithDoc
      singular
      yacas
    ];
  };

}
