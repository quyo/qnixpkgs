#
# build: nix --no-sandbox build qnixpkgs#danecheck
#
{ stdenv, fetchgit, gmp, icu, system }:

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

stdenv.mkDerivation {
  inherit pname version;

  # Disable the Nix build sandbox for this specific build.
  # This means the build can freely talk to the Internet.
  __noChroot = true;
  preferLocalBuild = true;

  src = fetchgit {
    url = "https://github.com/vdukhovni/danecheck.git";
    rev = commit;
    sha256 = "b7Zcsy5BOc3qPnfikLo2y6zNhmjwEdlSEgUsOLVvMi0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = with oldpkgs; [ stack haskell.compiler.ghc8107 ];
  buildInputs = [ gmp icu ];

  patchPhase = ''
    runHook prePatch

    sed -i -e 's|^resolver: lts-14\.10$|resolver: lts-18.10|' stack.yaml

    echo 'system-ghc: true' >> stack.yaml
    echo 'extra-include-dirs:' >> stack.yaml
    echo '- ${gmp}/include' >> stack.yaml
    echo '- ${icu}/include' >> stack.yaml
    echo 'extra-lib-dirs:' >> stack.yaml
    echo '- ${gmp}/lib' >> stack.yaml
    echo '- ${icu}/lib' >> stack.yaml

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
