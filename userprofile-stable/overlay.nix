version: final: prev:
{
  userprofile-stable = final.buildEnv
    {
      name = "userprofile-global-stable-${version}";
      paths = with final; [
        dotfiles
      ];
    };
}
