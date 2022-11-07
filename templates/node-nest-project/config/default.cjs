const defer = require("config/defer").deferConfig;
const raw = require("config/raw").raw;

const config = {
  env: {
    label: undefined,
    labelOutput: defer(function () {
      return "[" + this.env.label + "]";
    }),
  },
  backend: {
    logOutputStream: raw(process.stdout),
    server: {
      port: 3000,
    },
  },
};

module.exports = config;
