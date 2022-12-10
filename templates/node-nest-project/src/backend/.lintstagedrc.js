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
  "**/*.!({ts,tsx,cts,mts,js,jsx,cjs,mjs})":
    "prettier --write --cache --cache-strategy content --ignore-unknown",
};
