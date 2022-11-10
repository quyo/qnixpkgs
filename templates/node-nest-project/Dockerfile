# build-stage
FROM node:18-alpine as build-stage

WORKDIR /app

RUN apk --no-cache add g++ make python3

COPY package*.json .
RUN npm install

COPY . .
RUN npm run build:prod



# final-stage
FROM node:18-alpine as final-stage

WORKDIR /app

COPY package*.json .
RUN npm install --omit=dev husky

COPY --from=build-stage /app/config ./config
COPY --from=build-stage /app/dist ./dist

CMD ["npm", "run", "serve:prod"]

EXPOSE 3000

HEALTHCHECK CMD wget -q -O /dev/null http://localhost:3000 || exit 1
