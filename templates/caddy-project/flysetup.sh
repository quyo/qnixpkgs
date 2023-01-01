#!/usr/bin/env bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'


FLY_PROXY_PROTOCOL=$([[ ! "${PRJ_CADDY_ADDRESS}" =~ ^http:// ]] && echo -n tcp || echo -n http)

pushd "fly/caddy-${FLY_PROXY_PROTOCOL}"

project-setup-fly-app-domain

popd



if [[ ! "${PRJ_CADDY_ADDRESS}" =~ quyo\.(dev|cloud)$ ]]; then

    echo
    echo ">>> [${PRJ_CADDY_ADDRESS}] Caddy address does not end with quyo.dev or quyo.cloud - quyo subdomain will not work!"
    echo

fi
