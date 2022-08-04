self: final: prev:

let
  version = final.lib.q.flake.version self;
in

{
  userprofile-stable = final.buildEnv
    {
      name = "userprofile-global-stable-${version}";
      paths = with final; [
        dotfiles
      ];
    };
}
