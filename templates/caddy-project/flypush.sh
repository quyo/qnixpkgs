#!/usr/bin/env bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'


if [[ "${PRJ_IMAGE_CADDY}" =~ ^caddy: ]]; then

    echo ">>> [${PRJ_IMAGE_CADDY}] Deploying vanilla images with volumes are not supported yet - please use custom builds instead."
    exit 1

fi

if [[ "${PRJ_IMAGE_PHP:-}" =~ ^php: ]]; then

    echo ">>> [${PRJ_IMAGE_PHP:-}] Deploying vanilla images with volumes are not supported yet - please use custom builds instead."
    exit 1

fi



FLY_PROXY_PROTOCOL=$([[ ! "${PRJ_CADDY_ADDRESS}" =~ ^http:// ]] && echo -n tcp || echo -n http)
PHP_HOST=$([[ ! "${PRJ_IMAGE_PHP:-}" =~ ^$ ]] && echo -n ${PRJ_FLY_APP_NAME}-php.internal:9000 || echo -n)

pushd "fly/caddy-${FLY_PROXY_PROTOCOL}"

if [[ "${FLY_PROXY_PROTOCOL}" == "tcp" ]]; then

    (flyctl volumes list | grep caddy_storage >/dev/null) || flyctl volumes create caddy_storage --region ${PRJ_FLY_REGION} --size 1

fi

FLY_IMAGE_CADDY=registry.fly.io/${PRJ_FLY_APP_NAME}:$(date --utc +%Y%m%d-%H%M%S)

docker tag ${PRJ_IMAGE_CADDY} ${FLY_IMAGE_CADDY}
docker push ${FLY_IMAGE_CADDY} || (echo ; echo ">>> Maybe you missed to run 'flyctl auth docker' before?" ; exit 1)

echo
echo ">>> [ flyctl deploy --image ${FLY_IMAGE_CADDY} --env PHP_HOST=${PHP_HOST} ]"
echo

sed -i -E -e "s|CADDY_ADDRESS[=[:space:]].*$|CADDY_ADDRESS = \"${PRJ_CADDY_ADDRESS}\"|" fly.toml
flyctl deploy --image ${FLY_IMAGE_CADDY} --env PHP_HOST=${PHP_HOST}
sleep 15
flyctl status
flyctl info

popd



if [[ ! "${PRJ_IMAGE_PHP:-}" =~ ^$ ]]; then

    pushd "fly/php"

    FLY_IMAGE_PHP=registry.fly.io/${PRJ_FLY_APP_NAME}-php:$(date --utc +%Y%m%d-%H%M%S)

    docker tag ${PRJ_IMAGE_PHP} ${FLY_IMAGE_PHP}
    docker push ${FLY_IMAGE_PHP}

    echo
    echo ">>> [ flyctl deploy --image ${FLY_IMAGE_PHP} ]"
    echo

    flyctl deploy --image ${FLY_IMAGE_PHP}
    sleep 15
    flyctl status
    flyctl info

    popd

fi



if [[ ! "${PRJ_CADDY_ADDRESS}" =~ \.fly\.dev(,|$) ]]; then

    echo
    echo ">>> [${PRJ_CADDY_ADDRESS}] Caddy address does not contain fly.dev - automatic Fly.io subdomain will not work!"
    echo

fi
