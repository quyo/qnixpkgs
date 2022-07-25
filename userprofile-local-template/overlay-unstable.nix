version: final: prev:

{

  userprofile-local-unstable = final.buildEnv
  {
    name = "userprofile-local-unstable-${version}";
    paths = with final; [
    ];
  };

}
