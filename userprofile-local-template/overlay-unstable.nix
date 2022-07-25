version: final: prev:

{

  userprofile-local-unstable = final.symlinkJoin
  {
    name = "userprofile-local-unstable-${version}";

    paths = with final; [
    ];
  };

}
