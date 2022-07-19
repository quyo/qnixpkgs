{ stdenv, bash, coreutils, findutils, gnugrep, gnused }:

let
  pname = "linac";
  version = "0.9.3";

  src = builtins.fetchurl {
    url = "https://git.thisisjoes.site/joe/linac/releases/download/v${version}/linac";
    sha256 = "0x4kszzick1lib5d56h0bbacayqw2jjhjcm872kkq91043g9slz8";
  };
in

stdenv.mkDerivation {
  inherit pname version src;
  inherit bash coreutils findutils gnugrep gnused;

  buildInputs = [ bash coreutils findutils gnugrep gnused ];

  dontUnpack = true;

  patchPhase = ''
    runHook prePatch

    cp ${src} linac
    patch -p0 linac ${./linac.patch}
    substituteAllInPlace linac

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin -m755 linac

    runHook postInstall
  '';
}
