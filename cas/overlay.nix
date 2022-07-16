final: prev:

let
  py3 = prev.python3.withPackages (p: with p; [ gmpy2 mpmath sympy ]);
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
#     sage
      sagetex
      sageWithDoc
      singular
      yacas
    ];
  };

}
