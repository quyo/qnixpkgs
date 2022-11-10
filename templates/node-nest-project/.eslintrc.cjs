module.exports = {
  root: true,

  parser: "@typescript-eslint/parser",

  parserOptions: {
    project: "tsconfig.eslint.json",
    tsconfigRootDir: __dirname,
    sourceType: "module",
    ecmaFeatures: {
      strict: true,
      jsx: true,
    },
  },

  plugins: ["@typescript-eslint", "import"],

  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking",
    "plugin:import/recommended",
    "plugin:import/typescript",
    "prettier",
  ],

  rules: {},

  overrides: [
    {
      files: ["*.ts", "*.mts", "*.cts", "*.tsx"],
      rules: {
        "no-undef": "off",
      },
    },
  ],

  settings: {
    "import/extensions": [
      ".ts",
      ".mts",
      ".cts",
      ".tsx",
      ".js",
      ".mjs",
      ".cjs",
      ".jsx",
    ],
    "import/parsers": {
      "@typescript-eslint/parser": [".ts", ".mts", ".cts", ".tsx"],
    },
    "import/resolver": {
      typescript: {
        alwaysTryTypes: true, // always try to resolve types under `<root>@types` directory even it doesn't contain any source code, like `@types/unist`
        project: "tsconfig.eslint.json",
      },
    },
  },

  reportUnusedDisableDirectives: true,

  env: {
    es2022: true,
    node: true,
  },
};
