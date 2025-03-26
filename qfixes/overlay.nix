self: final: prev:

let
  inherit (prev) lib stdenv;
  inherit (final.lib.q) dontCheck dontInstallCheck dontCheckHaskell fixllvmPackages;

  stablePkgs = import self.inputs.nixpkgs-stable {
    system = stdenv.hostPlatform.system;
  };
in

{
  gawk-with-extensions = prev.gawk-with-extensions.override {
    extensions = builtins.filter (drv: drv.pname != "gawkextlib-haru" && drv.pname != "gawkextlib-select") final.gawkextlib.full;
  };

  glances = dontInstallCheck prev.glances;
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

    gdu = dontCheck prev.gdu;

    go_1_19 = prev.darwin.apple_sdk_11_0.callPackage go/1.19.nix {
      inherit (prev.darwin.apple_sdk_11_0.frameworks) Foundation Security;
    };
    go_1_20 = prev.darwin.apple_sdk_11_0.callPackage go/1.20.nix {
      inherit (prev.darwin.apple_sdk_11_0.frameworks) Foundation Security;
    };

    haskellPackages =
      let
        appendPatch = prev.haskell.lib.compose.appendPatch;
        overrideCabal = prev.haskell.lib.compose.overrideCabal;
      in
      prev.haskellPackages.extend (hfinal: hprev: {
        bsb-http-chunked = dontCheckHaskell hprev.bsb-http-chunked;
        crypton = dontCheckHaskell hprev.crypton;
        cryptonite = dontCheckHaskell hprev.cryptonite;
        half = dontCheckHaskell hprev.half;
        inline-c = dontCheckHaskell hprev.inline-c;
        inline-c-cpp = dontCheckHaskell hprev.inline-c-cpp;
        insert-ordered-containers = dontCheckHaskell hprev.insert-ordered-containers;
        lukko = dontCheckHaskell hprev.lukko;
        memory = dontCheckHaskell hprev.memory;
        relude = dontCheckHaskell hprev.relude;
        serialise = dontCheckHaskell hprev.serialise;
        SHA = dontCheckHaskell hprev.SHA;
        tasty = overrideCabal (drv: {
          libraryHaskellDepends = (drv.libraryHaskellDepends or []) ++ [ hfinal.unbounded-delays ];
        }) hprev.tasty;
        th-orphans = dontCheckHaskell hprev.th-orphans;
        time-compat = dontCheckHaskell hprev.time-compat;
      });

    httpie = dontInstallCheck prev.httpie;

    libdrm = prev.libdrm.override {
      withValgrind = false;
    };

    libgit2 = dontCheck prev.libgit2;

    libuv = dontCheck prev.libuv;

    llvmPackages = fixllvmPackages prev.llvmPackages;
    llvmPackages_12 = fixllvmPackages prev.llvmPackages_12;
    llvmPackages_13 = fixllvmPackages prev.llvmPackages_13;
    llvmPackages_14 = fixllvmPackages prev.llvmPackages_14;
    llvmPackages_latest = fixllvmPackages prev.llvmPackages_latest;

    openssh = dontCheck prev.openssh;

    pixman = prev.pixman.overrideAttrs (oldAttrs: {
      mesonFlags = (oldAttrs.mesonFlags or [ ]) ++ [
        "-Darm-simd=disabled"
        "-Dneon=disabled"
      ];
    });

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

    rust_1_85 = stablePkgs.rust;
  }
