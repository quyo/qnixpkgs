{ stdenv, fetchgit, linac, coreutils, curl, gnugrep, jq }:

let
  pname = "axon.sh";
  version = "0.17.0";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchgit {
    url = "https://git.thisisjoes.site/joe/axon.sh.git";
    rev = "refs/tags/v${version}";
    sha256 = "py77Z4c4NWKVKj3iaALfn3RqABxP9U12nOcmrgWxrTo=";
  };

  nativeBuildInputs = [ linac ];

  buildPhase = ''
    runHook preBuild

    linac build axon.sh.build

    sed -i -e '2s|^|PATH="${coreutils}/bin:${curl}/bin:${gnugrep}/bin:${jq}/bin"\n|' build/axon.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin -m755 build/axon.sh

    runHook postInstall
  '';
}
