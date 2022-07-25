version: final: prev:

{

  userprofile-local-stable = final.buildEnv
  {
    name = "userprofile-local-stable-${version}";
    paths = with final; [
    ];
  };

}
