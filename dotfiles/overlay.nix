version: final: prev:
{
  dotfiles = final.callPackage ./. { inherit version; };
}
