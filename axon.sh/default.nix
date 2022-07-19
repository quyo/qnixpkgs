{ stdenv, fetchgit, linac, bash, coreutils, curl, gnugrep, jq }:

let
  pname = "axon.sh";
  version = "0.17.0";

  cmd2pkg = {
    curl = curl;
    cut = coreutils;
    date = coreutils;
    echo = coreutils;
    fold = coreutils;
    grep = gnugrep;
    head = coreutils;
    jq = jq;
    mkdir = coreutils;
    printf = coreutils;
    shuf = coreutils;
    touch = coreutils;
    tr = coreutils;
  };

  cmdPatch =
    let inherit (builtins) attrValues concatStringsSep mapAttrs;
    in concatStringsSep "\n"
      (attrValues
        (mapAttrs
          (cmd: pkg: "find ./src -type f -exec sed -z -i -e 's|\\([([:space:]]\\)${cmd}\\([)[:space:]]\\)|\\1${pkg}/bin/${cmd}\\2|g' {} +")
          cmd2pkg
        )
      );
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchgit {
    url = "https://git.thisisjoes.site/joe/axon.sh.git";
    rev = "refs/tags/v${version}";
    sha256 = "py77Z4c4NWKVKj3iaALfn3RqABxP9U12nOcmrgWxrTo=";
  };

  nativeBuildInputs = [ linac ];
  buildInputs = [ bash coreutils curl gnugrep jq ];

  patchPhase = ''
    runHook prePatch

    ${cmdPatch}

    # revert "overpatching"
    find ./src -type f -exec sed -z -i -e 's|${coreutils}/bin/date or timestamp|date or timestamp|g' {} +
    find ./src -type f -exec sed -z -i -e 's|${jq}/bin/jq returned message|jq returned message|g' {} +

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    linac build axon.sh.build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin -m755 build/axon.sh

    runHook postInstall
  '';
}
