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
    rust_1_85 = nixpkgs-stable-overlayed.rust;
  }
