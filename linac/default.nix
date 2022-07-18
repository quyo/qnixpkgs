{ stdenv }:

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

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ${src} $out/bin/${pname}

    runHook postInstall
  '';
}
