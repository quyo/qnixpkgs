{ lib, stdenvNoCC, makeWrapper, coreutils, findutils, gnugrep, gnused }:

let
  pname = "linac";
  version = "0.9.4";

  src = builtins.fetchurl {
    url = "https://git.thisisjoes.site/joe/linac/releases/download/v${version}/linac";
    sha256 = "12cy99fiq03xyrsd0zglhc1ds6qg3pnnfi81k38vprdw0818hldq";
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
