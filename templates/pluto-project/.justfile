default:
  @just --list --justfile {{justfile()}}


just-setup:
  #!/usr/bin/env bash
  pushd {{justfile_directory()}}

  julia --project=. -e 'import Pkg; Pkg.add("Pluto")'

  touch .env
  mkdir -p notebooks/
  direnv allow

  git init -b main && git commit -a -m "Initial commit"

  popd


just-pluto:
  #!/usr/bin/env bash
  pushd {{justfile_directory()}}/notebooks/

  julia --project=.. -e 'import Pluto; Pluto.run()'

  popd
