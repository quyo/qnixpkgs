{ stdenvNoCC, version }:

stdenvNoCC.mkDerivation {
  pname = "dotfiles";
  inherit version;

  src = ./.;

  buildPhase = ''
    runHook preBuild

    mkdir $out
    cd src

    find . -mindepth 1 -maxdepth 1 ! -iname "*.tmpl" | xargs -i cp -r {} $out

    dirs=($(find . -mindepth 1 -maxdepth 1 -type d -iname "*.tmpl"))
    for dir in ''${dirs[@]}; do
      for file in $dir/* ; do
        cat $file >> $out/''${dir/%.tmpl/}
      done
    done

    runHook postBuild
  '';

  dontInstall = true;
}
