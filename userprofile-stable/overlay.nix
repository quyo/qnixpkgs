version: final: prev:

{

  userprofile-stable = final.symlinkJoin
  {
    name = "userprofile-stable-${version}";
    preferLocalBuild = false;
    allowSubstitutes = true;

    paths = with final; [
      hello
    ];
  };

}
