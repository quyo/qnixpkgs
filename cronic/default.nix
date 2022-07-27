{ lib, stdenvNoCC, makeWrapper, coreutils, gnugrep }:

let
  pname = "cronic";
  version = "3";
in

stdenvNoCC.mkDerivation {
  inherit pname version;

  src = ./cronic-v3;

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ''
    runHook preUnpack

    cp $src cronic

    runHook postUnpack
  '';

  patches = [ ./apply-cronic-ignore.patch ];
  patchFlags = "-p0";

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin -m755 cronic

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/cronic \
      --prefix PATH : ${lib.makeBinPath [ coreutils gnugrep ]}
  '';
}
