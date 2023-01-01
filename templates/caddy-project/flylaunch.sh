#!/usr/bin/env bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'


FLY_PROXY_PROTOCOL=$([[ ! "${PRJ_CADDY_ADDRESS}" =~ ^http:// ]] && echo -n tcp || echo -n http)

pushd "fly/caddy-${FLY_PROXY_PROTOCOL}"

echo
echo ">>> [ flyctl launch --auto-confirm --copy-config --name "${PRJ_FLY_APP_NAME}" --no-deploy --org ${PRJ_FLY_ORGANIZATION} --region ${PRJ_FLY_REGION} ]"
echo

flyctl launch --auto-confirm --copy-config --name "${PRJ_FLY_APP_NAME}" --no-deploy --org ${PRJ_FLY_ORGANIZATION} --region ${PRJ_FLY_REGION} || true

popd



if [[ ! "${PRJ_IMAGE_PHP:-}" =~ ^$ ]]; then

    pushd "fly/php"

    echo
    echo ">>> [ flyctl launch --auto-confirm --copy-config --name "${PRJ_FLY_APP_NAME}-php" --no-deploy --org ${PRJ_FLY_ORGANIZATION} --region ${PRJ_FLY_REGION} ]"
    echo

    flyctl launch --auto-confirm --copy-config --name "${PRJ_FLY_APP_NAME}-php" --no-deploy --org ${PRJ_FLY_ORGANIZATION} --region ${PRJ_FLY_REGION}

    popd

fi
