self: final: prev:

let
  inherit (prev) lib stdenv;
  inherit (final.lib.q) dontCheck dontInstallCheck dontCheckHaskell fixllvmPackages;
in

{
  gawk-with-extensions = prev.gawk-with-extensions.override {
    extensions = builtins.filter (drv: drv.pname != "gawkextlib-haru") final.gawkextlib.full;
  };
}
  // lib.optionalAttrs stdenv.hostPlatform.isAarch32
  {
    aws-c-common = dontCheck prev.aws-c-common;

    batwatch = dontCheck prev.batwatch;

    buildPackages = prev.buildPackages // {
      go_1_19 = final.go_1_19;
    };

    duplicity = dontInstallCheck prev.duplicity;

    ell = dontCheck prev.ell;

    go_1_19 = prev.darwin.apple_sdk_11_0.callPackage go/1.19.nix {
      inherit (prev.darwin.apple_sdk_11_0.frameworks) Foundation Security;
    };

    haskellPackages = prev.haskellPackages.extend (hfinal: hprev: {
      bsb-http-chunked = dontCheckHaskell hprev.bsb-http-chunked;
      cborg = dontCheckHaskell (hprev.cborg.overrideAttrs (oldAttrs: {
        p296 = ./cborg/p296.patch;
        postPatch = oldAttrs.postPatch or "" + ''
          patch -p2 <$p296
        '';
      }));
      cryptonite = dontCheckHaskell hprev.cryptonite;
      half = dontCheckHaskell hprev.half;
      inline-c = dontCheckHaskell hprev.inline-c;
      inline-c-cpp = dontCheckHaskell hprev.inline-c-cpp;
      insert-ordered-containers = dontCheckHaskell hprev.insert-ordered-containers;
      lukko = dontCheckHaskell hprev.lukko;
      relude = dontCheckHaskell hprev.relude;
      serialise = dontCheckHaskell hprev.serialise;
      th-orphans = dontCheckHaskell hprev.th-orphans;
      time-compat = dontCheckHaskell hprev.time-compat;
    });

    httpie = dontInstallCheck prev.httpie;

    llvmPackages = fixllvmPackages prev.llvmPackages;
    llvmPackages_12 = fixllvmPackages prev.llvmPackages_12;
    llvmPackages_13 = fixllvmPackages prev.llvmPackages_13;
    llvmPackages_14 = fixllvmPackages prev.llvmPackages_14;
    llvmPackages_latest = fixllvmPackages prev.llvmPackages_latest;

    openssh = dontCheck prev.openssh;

    pre-commit = prev.pre-commit.override { dotnet-sdk = null; };

    python3 = prev.python3 // {
      pkgs = prev.python3.pkgs.overrideScope (pyfinal: pyprev: {
        psutil = dontInstallCheck pyprev.psutil;
        sh = dontInstallCheck pyprev.sh;
      });
    };

    python39 = prev.python39 // {
      pkgs = prev.python39.pkgs.overrideScope (pyfinal: pyprev: {
        aiohttp = dontInstallCheck pyprev.aiohttp;
      });
    };

    python310 = prev.python310 // {
      pkgs = prev.python310.pkgs.overrideScope (pyfinal: pyprev: {
        psutil = dontInstallCheck pyprev.psutil;
        sh = dontInstallCheck pyprev.sh;
      });
    };
  }
