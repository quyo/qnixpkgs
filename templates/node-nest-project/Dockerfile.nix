# build-stage
FROM nixos/nix:2.11.1 as build-stage
ENV NIX_CONFIG="experimental-features = nix-command flakes repl-flake"

WORKDIR /app

COPY flake* .

COPY package*.json .
RUN nix shell .#devenv -c npm install

COPY . .
RUN nix shell .#devenv -c npm run build:prod

RUN rm -rf ./node_modules
RUN nix shell .#devenv -c npm install --omit=dev husky



# final-stage
FROM nixos/nix:2.11.1 as final-stage
ENV NIX_CONFIG="experimental-features = nix-command flakes repl-flake"

WORKDIR /app

COPY flake* .

RUN nix profile install .#runtime && nix-collect-garbage -d

COPY --from=build-stage /app/package*.json .
COPY --from=build-stage /app/config ./config
COPY --from=build-stage /app/dist ./dist
COPY --from=build-stage /app/node_modules ./node_modules

ENV NODE_ENV="production"
ENV NODE_OPTIONS="--experimental-specifier-resolution=node --enable-source-maps"

CMD ["node", "./dist/backend/app.js"]

EXPOSE 3000

HEALTHCHECK CMD wget -q -O /dev/null http://localhost:3000 || exit 1
