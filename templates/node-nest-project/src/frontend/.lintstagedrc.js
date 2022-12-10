import { ESLint } from "eslint";

const eslint = new ESLint();

export default {
  "**/*.{ts,tsx,cts,mts,js,jsx,cjs,mjs}": (files) => [
    `eslint --max-warnings=0 --cache --cache-strategy content ${files
      .filter((file) => !eslint.isPathIgnored(file))
      .map((f) => `"${f}"`)
      .join(" ")}`,
    `prettier --write --cache --cache-strategy content --ignore-unknown ${files
      .map((f) => `"${f}"`)
      .join(" ")}`,
  ],
  "**/*.{css,scss,sass,less}": [
    "stylelint --max-warnings=0 --cache --cache-strategy content",
    "prettier --write --cache --cache-strategy content --ignore-unknown",
  ],
  "**/*.!({ts,tsx,cts,mts,js,jsx,cjs,mjs,css,scss,sass,less})":
    "prettier --write --cache --cache-strategy content --ignore-unknown",
};
