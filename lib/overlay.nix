self: final: prev:

let
  inherit (builtins) all attrNames filter substring;

  qlib = {

    extendEnv = baseEnv: pname: version: paths: baseEnv.overrideAttrs (oldAttrs: {
      inherit pname version;
      name = "${pname}-${version}";
      paths = (oldAttrs.paths or [ ]) ++ paths;
    });

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
    q = qlib;
  };
}
