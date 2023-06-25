default:
  @just --list --justfile {{justfile()}}


just-setup:
  #!/usr/bin/env bash
  pushd {{justfile_directory()}}

  julia --project=. -e 'import Pkg; Pkg.add("Pluto")'

  [ ! -e .git ] && git init -b main && git add . && git commit -m "Initial commit"

  touch .env
  mkdir -p notebooks/

  direnv allow

  popd


just-pluto:
  #!/usr/bin/env bash
  pushd {{justfile_directory()}}/notebooks/

  julia --project=.. -e 'import Pluto; Pluto.run()'

  popd
