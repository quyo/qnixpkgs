self: final: prev:

let
  version = final.lib.q.flake.version self;
in

{
  dotfiles = final.callPackage ./. { inherit version; };
}
