#!/usr/bin/env bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'


COMPOSE_CONFIG_FILES=("-f docker-compose.caddy.yml")

if [[ "${PRJ_IMAGE_CADDY}" =~ ^caddy: ]]; then

    COMPOSE_CONFIG_FILES+=("-f docker-compose.caddy-vanilla.yml")

fi

if [[ ! "${PRJ_CADDY_ADDRESS}" =~ ^http:// ]]; then

    COMPOSE_CONFIG_FILES+=("-f docker-compose.caddy-https.yml")

fi

if [[ ! "${PRJ_IMAGE_PHP:-}" =~ ^$ ]]; then

    COMPOSE_CONFIG_FILES+=("-f docker-compose.php.yml")

fi

if [[ "${PRJ_IMAGE_PHP:-}" =~ ^php: ]]; then

    COMPOSE_CONFIG_FILES+=("-f docker-compose.php-vanilla.yml")

fi

echo
echo ">>> [ docker-compose ${COMPOSE_CONFIG_FILES[@]} $@ ]"
echo

eval "docker-compose ${COMPOSE_CONFIG_FILES[@]} $@"
