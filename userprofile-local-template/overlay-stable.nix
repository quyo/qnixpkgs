version: final: prev:

{

  userprofile-local-stable = final.symlinkJoin
  {
    name = "userprofile-local-stable-${version}";

    paths = with final; [
    ];
  };

}
