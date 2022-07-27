{ lib, stdenvNoCC, makeWrapper, coreutils, findutils, gnugrep, gnused }:

let
  pname = "linac";
  version = "0.9.3";

  src = builtins.fetchurl {
    url = "https://git.thisisjoes.site/joe/linac/releases/download/v${version}/linac";
    sha256 = "0x4kszzick1lib5d56h0bbacayqw2jjhjcm872kkq91043g9slz8";
  };
in

stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D -m755 ${src} $out/bin/linac

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/linac \
      --prefix PATH : ${lib.makeBinPath [ coreutils findutils gnugrep gnused ]}
  '';
}
