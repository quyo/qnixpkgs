self: final: prev:

let
  inherit (prev) lib stdenv;

  dontCheck = drv: drv.overrideAttrs (oldAttrs: {
    doCheck = false;
  });

  dontInstallCheck = drv: drv.overrideAttrs (oldAttrs: {
    doInstallCheck = false;
  });

  dontCheckHaskell = prev.haskell.lib.dontCheck;

  dontCheckLLVM = drv: drv.overrideAttrs (oldAttrs: {
    doCheck = false;
    cmakeFlags = map (x: builtins.replaceStrings ["DLLVM_BUILD_TESTS=ON"] ["DLLVM_BUILD_TESTS=OFF"] x) oldAttrs.cmakeFlags;
  });

  fixllvmPackages = llvmPkgs: llvmPkgs // (
    let
      tools = llvmPkgs.tools.extend (tfinal: tprev: {
        libllvm = dontCheckLLVM tprev.libllvm;
      });
    in
    { inherit tools; } // tools
  );
in

{
}
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
