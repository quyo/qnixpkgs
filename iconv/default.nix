{ stdenvNoCC, glibc }:

stdenvNoCC.mkDerivation {
  pname = "iconv";
  version = glibc.version;

  buildInputs = [ glibc ];

  dontUnpack = true;

  installPhase = "install -Dt $out/bin -m755 ${glibc.bin}/bin/iconv";
}
