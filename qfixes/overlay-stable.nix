self: final: prev:

let
  inherit (prev) fetchpatch lib stdenv;
  inherit (final.lib.q) dontCheck dontInstallCheck dontCheckHaskell fixllvmPackages;

  nixpkgs-stable-overlayed = self.outputs.nixpkgs-stable.${stdenv.hostPlatform.system};
  nixpkgs-stable-vanilla = import self.inputs.nixpkgs-stable {
    system = stdenv.hostPlatform.system;
  };

  nixpkgs-unstable-overlayed = self.outputs.nixpkgs-unstable.${stdenv.hostPlatform.system};
  nixpkgs-unstable-vanilla = import self.inputs.nixpkgs-unstable {
    system = stdenv.hostPlatform.system;
  };
in

{ }
  // lib.optionalAttrs stdenv.hostPlatform.isAarch32
  {
    pandoc = nixpkgs-unstable-overlayed.pandoc;

    python312 = prev.python312 // {
      pkgs = prev.python312.pkgs.overrideScope (pyfinal: pyprev: {
        httpie = pyprev.httpie.overridePythonAttrs (oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pyfinal.pip ];
        });
        pendulum = pyprev.pendulum.overridePythonAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [ ]) ++ [
            (fetchpatch {
              url = "https://github.com/sdispater/pendulum/commit/6f2fcb8b025146ae768a5889be4a437fbd3156d6.patch";
              hash = "sha256-47591JvpADxGQT2q7EYWHfStaiWyP7dt8DPTq0tiRvk=";
            })
          ];
        });
      });
    };
  }
