#
# build: nix --no-sandbox build qnixpkgs#danecheck
#
{ stdenv, fetchgit, gmp, icu, stack }:

let
  pname = "danecheck";
  version = "0.20191017." + builtins.substring 0 8 commit;
  commit = "250fb3d8d87bddc5ca2de33b83cb0bdd518b3296";
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

  nativeBuildInputs = [ stack ];
  buildInputs = [ gmp icu ];

  patchPhase = ''
    runHook prePatch

    sed -i -e 's|^resolver: lts-14\.10$|resolver: lts-18.10|' stack.yaml

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
    stack --verbose --stack-root $PWD/.stack --local-bin-path $out/bin install

    runHook postBuild
  '';

  dontInstall = true;
}
