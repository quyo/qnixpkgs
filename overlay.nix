self: super:
{

  # this key should be the same as the flake name attribute.
  qnixpkgs-flake = import duply/overlay.nix self super;

}
