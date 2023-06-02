self: final: prev:

let
  inherit (builtins) all attrNames filter substring;

  qlib = rec {

    dontCheck = drv: drv.overrideAttrs (oldAttrs: {
      doCheck = false;
      checkInputs = [];
      preCheck = null;
      postCheck = null;
    });

    dontInstallCheck = drv: drv.overrideAttrs (oldAttrs: {
      doInstallCheck = false;
      checkInputs = [];
      preCheck = null;
      postCheck = null;
    });

    dontCheckHaskell = prev.haskell.lib.dontCheck;

    dontCheckLLVM = drv: drv.overrideAttrs (oldAttrs: {
      doCheck = false;
      checkInputs = [];
      cmakeFlags = map (x: builtins.replaceStrings [ "DLLVM_BUILD_TESTS=ON" ] [ "DLLVM_BUILD_TESTS=OFF" ] x) oldAttrs.cmakeFlags;
    });

    extendEnv = baseEnv: pname: version: paths: baseEnv.overrideAttrs (oldAttrs: {
      inherit pname version;
      name = "${pname}-${version}";
      paths = (oldAttrs.paths or [ ]) ++ paths;
    });

    fixllvmPackages = llvmPkgs: llvmPkgs // (
      let
        tools = llvmPkgs.tools.extend (tfinal: tprev: {
          libllvm = dontCheckLLVM tprev.libllvm;
        });
      in
      { inherit tools; } // tools
    );

    flake = {
      apps = flakepkgs: appsnix: qlib.removeOverrideFuncs (final.lib.callPackageWith flakepkgs appsnix { });

      devShells = devshelltoml:
        {
          default = final.devshell.mkShell { imports = [ (final.devshell.importTOML devshelltoml) ]; };
        };

      formatter = final.nixpkgs-fmt;

      packages = name: version: flakepkgs: exclusions: dockernix: flakepkgs //
        {
          default = final.linkFarmFromDrvs "${name}-default-${version}" (qlib.removeListAttrs flakepkgs (exclusions.from-default or [ ]));

          ci-build = final.linkFarmFromDrvs "${name}-ci-build-${version}" (qlib.removeListAttrs flakepkgs (exclusions.from-ci-build or [ ]));
          ci-publish = final.linkFarmFromDrvs "${name}-ci-publish-${version}" (qlib.removeListAttrs flakepkgs (exclusions.from-ci-publish or [ ]));

          docker = qlib.overrideName (final.lib.callPackageWith (final // flakepkgs) dockernix { }) "${name}-docker" version;
        };

      version = flake:
        "0.${substring 0 8 flake.lastModifiedDate}.${substring 8 6 flake.lastModifiedDate}.${flake.shortRev or "dirty"}";
    };

    mapPkgs = attrs: pkgs: prefix: suffix: builtins.listToAttrs (map (x: final.lib.attrsets.nameValuePair "${prefix}${x}${suffix}" pkgs.${x}) attrs);

    overrideName = set: pname: version: set.overrideAttrs (oldAttrs: {
      inherit pname version;
      name = "${pname}-${version}";
    });

    removeListAttrs = list: exclude: map (x: list.${x}) (filter (x: all (y: x != y) exclude) (attrNames list));

    removeOverrideFuncs = set: removeAttrs set [ "override" "overrideDerivation" ];

  };
in

{
  lib = prev.lib // {
    q = (prev.q or { }) // qlib;
  };
}
