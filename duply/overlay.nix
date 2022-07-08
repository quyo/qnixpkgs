final: prev:

{

  duplicity = prev.duplicity.overrideAttrs (oldAttrs: {
    pythonPath = (oldAttrs.pythonPath or []) ++ [ prev.python3.pkgs.boto ];
  });

  duply = prev.duply.override { duplicity = final.duplicity; };

}
