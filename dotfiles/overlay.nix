self: final: prev:

let
  version = final.lib.q.flakeVersion self;
in

{
  dotfiles = final.callPackage ./. { inherit version; };
}
