#!/usr/bin/env bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'


if [[ ! "${PRJ_IMAGE_CADDY}" =~ ^caddy:|^$ ]]; then

    echo
    echo ">>> [ docker build -t ${PRJ_IMAGE_CADDY} --build-arg CADDY_BASE_IMAGE=${PRJ_IMAGE_CADDY_BASE} -f Dockerfile.caddy . ]"
    echo

    docker build -t ${PRJ_IMAGE_CADDY} --build-arg CADDY_BASE_IMAGE=${PRJ_IMAGE_CADDY_BASE} -f Dockerfile.caddy .

fi

if [[ ! "${PRJ_IMAGE_PHP:-}" =~ ^php:|^$ ]]; then

    echo
    echo ">>> [ docker build -t ${PRJ_IMAGE_PHP} --build-arg PHP_BASE_IMAGE=${PRJ_IMAGE_PHP_BASE} --build-arg PHP_MODE=${PRJ_IMAGE_PHP_MODE} -f Dockerfile.php . ]"
    echo

    docker build -t ${PRJ_IMAGE_PHP} --build-arg PHP_BASE_IMAGE=${PRJ_IMAGE_PHP_BASE} --build-arg PHP_MODE=${PRJ_IMAGE_PHP_MODE} -f Dockerfile.php .

fi
