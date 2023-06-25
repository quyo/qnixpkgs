default:
  @just --list --justfile {{justfile()}}


setup:
  #!/usr/bin/env bash
  pushd {{justfile_directory()}}

  julia --project=. -e 'import Pkg; Pkg.add("Pluto")'

  [ ! -e .git ] && git init -b main && git add . && git commit -m "Initial commit"

  touch .env
  mkdir -p notebooks/

  direnv allow

  popd


pluto:
  #!/usr/bin/env bash
  pushd {{justfile_directory()}}/notebooks/

  julia --project=.. -e 'import Pluto; Pluto.run()'

  popd
