version: final: prev:

let
  py3 = final.python3.withPackages (p: with p; [ gmpy2 mpmath sympy ]);
in

{

  cas = final.buildEnv
  {
    name = "cas-${version}";
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
