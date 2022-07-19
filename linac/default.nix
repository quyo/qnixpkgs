{ stdenv, bash, coreutils, findutils, gnugrep, gnused }:

let
  pname = "linac";
  version = "0.9.3";

  src = builtins.fetchurl {
    url = "https://git.thisisjoes.site/joe/linac/releases/download/v${version}/linac";
    sha256 = "0x4kszzick1lib5d56h0bbacayqw2jjhjcm872kkq91043g9slz8";
  };

  cmd2pkg = {
    cat = coreutils;
    cut = coreutils;
    date = coreutils;
    echo = coreutils;
    find = findutils;
    grep = gnugrep;
    mkdir = coreutils;
    printf = coreutils;
    sed = gnused;
    touch = coreutils;
    wc = coreutils;
  };

  cmdPatch =
    let inherit (builtins) attrValues concatStringsSep mapAttrs;
    in concatStringsSep "\n"
      (attrValues
        (mapAttrs
          (cmd: pkg: "sed -z -i -e 's|\\([([:space:]]\\)${cmd}\\([)[:space:]]\\)|\\1${pkg}/bin/${cmd}\\2|g' linac")
          cmd2pkg
        )
      );
in

stdenv.mkDerivation {
  inherit pname version src;

  buildInputs = [ bash coreutils findutils gnugrep gnused ];

  dontUnpack = true;

  patchPhase = ''
    runHook prePatch

    cp ${src} linac
    ${cmdPatch}

    # patch echo call in sed expressions (WTF?!)
    sed -i -e 's#s/$expression/echo \([^/]*\)/ge#s|$expression|${coreutils}/bin/echo \1|ge#g' linac

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin -m755 linac

    runHook postInstall
  '';
}
