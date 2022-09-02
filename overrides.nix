self: final: prev:

let
  inherit (prev) lib stdenv;

  dontCheck = drv: drv.overrideAttrs (oldAttrs: {
    doCheck = false;
  });

  dontCheckLLVM = drv: drv.overrideAttrs (oldAttrs: {
    doCheck = false;
    cmakeFlags = map (x: builtins.replaceStrings ["DLLVM_BUILD_TESTS=ON"] ["DLLVM_BUILD_TESTS=OFF"] x) oldAttrs.cmakeFlags;
  });

  fixllvmPackages = llvmPkgs: llvmPkgs // rec
  {
    tools = llvmPkgs.tools // rec
    {
      libllvm = dontCheckLLVM llvmPkgs.tools.libllvm;
      llvm = libllvm.out // { outputSpecified = false; };
      libclang = llvmPkgs.tools.libclang.override { inherit libllvm; };
      clang-unwrapped = libclang.out // { outputSpecified = false; };
    };
    libllvm = tools.libllvm;
    llvm = tools.llvm;
    libclang = tools.libclang;
    clang-unwrapped = tools.clang-unwrapped;
  };

  haskellPackagesOverrides = hfinal: hprev: {
    cryptonite = prev.haskell.lib.dontCheck hprev.cryptonite;
  }
  // lib.optionalAttrs (builtins.hasAttr "overrides" prev.haskellPackages) (prev.haskellPackages.overrides hfinal hprev);
in

{
}
// lib.optionalAttrs stdenv.hostPlatform.isAarch32
{
  ell = dontCheck prev.ell;

  haskellPackages = prev.haskellPackages.override {
    overrides = haskellPackagesOverrides;
  } // { overrides = haskellPackagesOverrides; };

  llvmPackages = fixllvmPackages prev.llvmPackages;
  llvmPackages_12 = fixllvmPackages prev.llvmPackages_12;
  llvmPackages_13 = fixllvmPackages prev.llvmPackages_13;
  llvmPackages_14 = fixllvmPackages prev.llvmPackages_14;

  python3 = prev.python3.override {
    packageOverrides = pyfinal: pyprev: {
      sh = dontCheck pyprev.sh;
    };
  };
}
