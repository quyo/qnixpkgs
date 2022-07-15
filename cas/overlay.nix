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

    paths = with prev; [
      maxima
      octave
      pari
      py3
#     sagetex
#     sageWithDoc
      yacas
    ];
  };

}
