self: final: prev:

let
  inherit (prev) lib stdenv;
  inherit (final.lib.q) dontCheck dontInstallCheck dontCheckHaskell fixllvmPackages;
in

{
  gawk-with-extensions = prev.gawk-with-extensions.override {
    extensions = builtins.filter (drv: drv.pname != "gawkextlib-haru" && drv.pname != "gawkextlib-select") final.gawkextlib.full;
  };
}
  // lib.optionalAttrs stdenv.hostPlatform.isAarch32
  {
    aws-c-common = dontCheck prev.aws-c-common;

    batwatch = dontCheck prev.batwatch;

    bind = dontCheck prev.bind;

    buildPackages = prev.buildPackages // {
      go_1_19 = final.go_1_19;
      go_1_20 = final.go_1_20;
    };

    dotnet-sdk = null;

    duplicity = dontInstallCheck prev.duplicity;

    ell = dontCheck prev.ell;

    fish = dontCheck prev.fish;

    go_1_19 = prev.darwin.apple_sdk_11_0.callPackage go/1.19.nix {
      inherit (prev.darwin.apple_sdk_11_0.frameworks) Foundation Security;
    };
    go_1_20 = prev.darwin.apple_sdk_11_0.callPackage go/1.20.nix {
      inherit (prev.darwin.apple_sdk_11_0.frameworks) Foundation Security;
    };

    haskellPackages =
      let
        appendPatch = prev.haskell.lib.compose.appendPatch;
      in
      prev.haskellPackages.extend (hfinal: hprev: {
        basement = appendPatch ./basement/basement-fix-32-bit.patch hprev.basement;
        bsb-http-chunked = dontCheckHaskell hprev.bsb-http-chunked;
        cborg = dontCheckHaskell (appendPatch ./cborg/p296.patch hprev.cborg);
        cryptonite = dontCheckHaskell hprev.cryptonite;
        half = dontCheckHaskell hprev.half;
        inline-c = dontCheckHaskell hprev.inline-c;
        inline-c-cpp = dontCheckHaskell hprev.inline-c-cpp;
        insert-ordered-containers = dontCheckHaskell hprev.insert-ordered-containers;
        lukko = dontCheckHaskell hprev.lukko;
        memory = appendPatch ./memory/pr98.patch hprev.memory;
        relude = dontCheckHaskell hprev.relude;
        serialise = dontCheckHaskell hprev.serialise;
        SHA = dontCheckHaskell hprev.SHA;
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

    pre-commit = dontInstallCheck prev.pre-commit;

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
