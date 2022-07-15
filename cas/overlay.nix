final: prev:

{

  cas = prev.symlinkJoin
  {
    name = "cas";
    preferLocalBuild = false;
    allowSubstitutes = true;
    paths = with prev; [
      maxima
      octave
#     sagetex
#     sageWithDoc
      yacas
    ];
  };

}
