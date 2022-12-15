# build-stage
FROM nixos/nix:2.11.1 as build-stage

WORKDIR /app

ENV NIX_CONFIG="experimental-features = nix-command flakes repl-flake"
COPY flake* .

COPY package*.json .
RUN nix shell .#devenv -c npm install

COPY . .
RUN nix shell .#devenv -c npm run build:prod



# final-stage
FROM nixos/nix:2.11.1 as final-stage

WORKDIR /app

ENV NIX_CONFIG="experimental-features = nix-command flakes repl-flake"
COPY flake* .

RUN nix profile install .#runtime && nix-collect-garbage -d

COPY package*.json .
RUN /root/.nix-profile/bin/npm install --omit=dev husky

COPY --from=build-stage /app/config ./config
COPY --from=build-stage /app/dist ./dist

CMD ["/root/.nix-profile/bin/npm", "run", "serve:prod"]

EXPOSE 3000

HEALTHCHECK CMD wget -q -O /dev/null http://localhost:3000 || exit 1
