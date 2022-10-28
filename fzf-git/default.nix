{ stdenv, fetchFromGitHub }:

let
  pname = "fzf-git";
  version = "0.20220930." + builtins.substring 0 8 commit;
  commit = "9190e1bf7273d85f435fa759a5c3b20e588e9f7e";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = "fzf-git.sh";
    rev = commit;
    sha256 = "2CGjk1oTXip+eAJMuOk/X3e2KTwfwzcKTcGToA2xPd4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out/share/fzf-git -m644 fzf-git.sh

    runHook postInstall
  '';
}
