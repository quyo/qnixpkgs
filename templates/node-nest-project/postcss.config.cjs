const autoprefixer = require("autoprefixer");
const postcssImport = require("postcss-import");
const postcssPresetEnv = require("postcss-preset-env");

module.exports = {
  plugins: [
    postcssImport(),
    /* autoprefixer(), */
    postcssPresetEnv({
      /* use stage 2 features + css nesting rules */
      stage: 2,
      features: {
        "nesting-rules": true,
      },
    }),
  ],
};
