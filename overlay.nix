externals: self: super:

let

  duply = import duply/overlay.nix self super;

in

{

  # this key should be the same as the flake name attribute.
  qnixpkgs-flake = externals // duply;

}
