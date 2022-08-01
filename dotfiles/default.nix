{ stdenvNoCC, version }:

stdenvNoCC.mkDerivation {
  pname = "dotfiles";
  inherit version;

  src = ./.;

  buildPhase = ''
    runHook preBuild

    cp -rT copy/ $out

    cd build/
    dirs=($(find . -mindepth 1 -maxdepth 1 -type d))
    for dir in ''${dirs[@]}; do
      for file in $dir/* ; do
        cat $file >> $out/$dir
      done
    done

    runHook postBuild
  '';

  dontInstall = true;
}
