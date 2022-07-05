self: super:
rec {

  duplicity = super.duplicity.overrideAttrs (oldAttrs: {
    pythonPath = oldAttrs.pythonPath ++ [ super.python3.pkgs.boto ];
  });

  duply = super.duply.override { inherit duplicity; };

}
