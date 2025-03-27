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
    cachix = nixpkgs-stable-overlayed.cachix;

    haskellPackages =
      let
        inherit (prev.haskell.lib.compose) appendPatch overrideCabal;
      in
      prev.haskellPackages.extend (hfinal: hprev: {
        cborg = dontCheckHaskell (appendPatch (fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/well-typed/cborg/pull/337.patch";
          hash = "sha256-TCAYFPm5Zh0p1/dTs1vfvpFS3MT7F7+bGI2nb0m3xY8=";
          stripLen = 1;
        }) hprev.cborg);
        tasty = overrideCabal (drv: {
          libraryHaskellDepends = (drv.libraryHaskellDepends or []) ++ [ hfinal.unbounded-delays ];
        }) hprev.tasty;
        tasty_1_5 = overrideCabal (drv: {
          libraryHaskellDepends = (drv.libraryHaskellDepends or []) ++ [ hfinal.unbounded-delays ];
        }) hprev.tasty_1_5;
        tasty_1_5_2 = overrideCabal (drv: {
          libraryHaskellDepends = (drv.libraryHaskellDepends or []) ++ [ hfinal.unbounded-delays ];
        }) hprev.tasty_1_5_2;
      });

    pixman = prev.pixman.overrideAttrs (oldAttrs: {
      mesonFlags = (oldAttrs.mesonFlags or [ ]) ++ [
        "-Darm-simd=disabled"
        "-Dneon=disabled"
      ];
    });

    rust_1_85 = nixpkgs-stable-overlayed.rust;
  }
