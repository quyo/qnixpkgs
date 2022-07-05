self: super:
rec {

  duplicity = super.duplicity.overrideAttrs (oldAttrs: {
    pythonPath = (oldAttrs.pythonPath or []) ++ [ super.python3.pkgs.boto ];
  });

  duply = super.duply.override { inherit duplicity; };

}
