self: final: prev:

let
  inherit (prev) lib stdenv;
  inherit (prev.lib.q) dontCheck dontInstallCheck dontCheckHaskell fixllvmPackages;
in

{ }
  // lib.optionalAttrs stdenv.hostPlatform.isAarch32
  {
    duplicity = dontInstallCheck prev.duplicity;

    ell = dontCheck prev.ell;

    haskellPackages = prev.haskellPackages.extend (hfinal: hprev: {
      cryptonite = dontCheckHaskell hprev.cryptonite;
    });

    llvmPackages = fixllvmPackages prev.llvmPackages;
    llvmPackages_12 = fixllvmPackages prev.llvmPackages_12;
    llvmPackages_13 = fixllvmPackages prev.llvmPackages_13;
    llvmPackages_14 = fixllvmPackages prev.llvmPackages_14;
    llvmPackages_latest = fixllvmPackages prev.llvmPackages_latest;

    python3 = prev.python3 // {
      pkgs = prev.python3.pkgs.overrideScope (pyfinal: pyprev: {
        sh = dontInstallCheck pyprev.sh;
      });
    };

    python39 = prev.python39 // {
      pkgs = prev.python39.pkgs.overrideScope (pyfinal: pyprev: {
        aiohttp = dontInstallCheck pyprev.aiohttp;
      });
    };
  }
