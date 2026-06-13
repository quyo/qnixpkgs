#
# build: nix --no-sandbox build qnixpkgs#danecheck
#
# Hinweis zur glibc-Konsistenz:
#   GHC 8.10.7 / Stack stammen aus dem gepinnten `oldpkgs` und sind gegen
#   dessen glibc (2.40) gebaut. Damit es zu keinem glibc-Mix kommt, MUESSEN
#   alle Bestandteile, die ins Linken/in die Laufzeit eingehen (stdenv, gmp,
#   icu, fetchgit), aus demselben `oldpkgs` kommen. Das aktuelle Flake-nixpkgs
#   (z. B. 26.05 mit glibc 2.42) liefert hier nur noch `system` als Argument.
#
{ system }:

let
  pname = "danecheck";
  version = "0.20191017." + builtins.substring 0 8 commit;
  commit = "250fb3d8d87bddc5ca2de33b83cb0bdd518b3296";

  oldpkgs = import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/54fb1628f3fa26e0e22a60e464fb3b380f6080cf.tar.gz";
      sha256 = "wmUuXpPXofQkyVHq60XDJrJJg58V2ajAbM4C9B+Hj8I=";
    })
    { inherit system; };

in

# Das gesamte Derivation im stdenv von `oldpkgs` bauen -> exakt eine glibc.
oldpkgs.stdenv.mkDerivation {
  inherit pname version;

  # Disable the Nix build sandbox for this specific build.
  # This means the build can freely talk to the Internet.
  __noChroot = true;
  preferLocalBuild = true;

  src = oldpkgs.fetchgit {
    url = "https://github.com/vdukhovni/danecheck.git";
    rev = commit;
    sha256 = "b7Zcsy5BOc3qPnfikLo2y6zNhmjwEdlSEgUsOLVvMi0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = with oldpkgs; [ stack haskell.compiler.ghc8107 ];
  buildInputs = with oldpkgs; [ gmp icu ];

  patchPhase = ''
    runHook prePatch

    sed -i -e 's|^resolver: lts-14\.10$|resolver: lts-18.10|' stack.yaml

    echo 'system-ghc: true' >> stack.yaml
    echo 'extra-include-dirs:' >> stack.yaml
    echo '- ${oldpkgs.gmp}/include' >> stack.yaml
    echo '- ${oldpkgs.icu}/include' >> stack.yaml
    echo 'extra-lib-dirs:' >> stack.yaml
    echo '- ${oldpkgs.gmp}/lib' >> stack.yaml
    echo '- ${oldpkgs.icu}/lib' >> stack.yaml

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin
    stack --no-nix --system-ghc --stack-root $PWD/.stack --local-bin-path $out/bin install

    runHook postBuild
  '';

  dontInstall = true;
}
