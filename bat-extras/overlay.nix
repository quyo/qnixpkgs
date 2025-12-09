self: final: prev:
let
  bat-extras = final.lib.recurseIntoAttrs (final.callPackages ./. { });
in
{
  batdiff = bat-extras.batdiff;
  batgrep = bat-extras.batgrep;
  batman = bat-extras.batman;
  batpipe = bat-extras.batpipe;
  batwatch = bat-extras.batwatch;
  prettybat = bat-extras.prettybat;
}
