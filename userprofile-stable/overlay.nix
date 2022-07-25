version: final: prev:

{

  userprofile-stable = final.symlinkJoin
  {
    name = "userprofile-global-stable-${version}";
    preferLocalBuild = false;
    allowSubstitutes = true;

    paths = with final; [
    ];
  };

}
