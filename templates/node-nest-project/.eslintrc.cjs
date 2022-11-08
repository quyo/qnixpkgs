module.exports = {
  root: true,

  parser: "@typescript-eslint/parser",

  parserOptions: {
    project: "tsconfig.json",
    tsconfigRootDir: __dirname,
    sourceType: "module",
    ecmaFeatures: {
      strict: true,
      jsx: true,
    },
  },

  plugins: ["@typescript-eslint/eslint-plugin"],

  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "prettier",
  ],

  rules: {},

  reportUnusedDisableDirectives: true,

  env: {
    es2022: true,
    node: true,
  },
};
