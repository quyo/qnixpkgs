{ stdenv, fetchFromGitHub }:

let
  pname = "fzf-git";
  version = "0.20221222." + builtins.substring 0 8 commit;
  commit = "f36662f603095a66fd0af83409eca36b94607021";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = "fzf-git.sh";
    rev = commit;
    sha256 = "sha256-ynsPnuJY3wm9EPJKY+8uV30nfWOiq81/JuG526eIoSA=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out/share/fzf-git -m644 fzf-git.sh

    runHook postInstall
  '';
}
