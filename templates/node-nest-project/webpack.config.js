import HtmlWebpackPlugin from "html-webpack-plugin";
import MiniCssExtractPlugin from "mini-css-extract-plugin";
import path from "path";
import url from "url";

const __filename = url.fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const src = path.resolve(__dirname, "src/frontend/public");

const entryPoints = {
  "css/global": [`${src}/css/global`],
  "js/app": [`${src}/js/app`],
  "module/foo": [`${src}/module/foo`],
  // "other output points" : ["other entry point"]
};

export default (
  /** @type {any} */ _env,
  /** @type {{ mode: string; }} */ argv
) => {
  const isDevelopmentMode = argv.mode === "development";

  // Locally, we want robust source-maps. However, in production, we want something
  // that can help with debugging without giving away all of the source-code. This
  // production setting will give us proper file-names and line-numbers for debugging;
  // but, without actually providing any code content.
  const devtool = isDevelopmentMode
    ? "eval-source-map"
    : "nosources-source-map";

  var plugins = [];
  plugins.push(
    new MiniCssExtractPlugin({
      filename: "[name].[contenthash].css",
      chunkFilename: "chunk/[id].[contenthash].css",
    })
  );

  /* eslint-disable @typescript-eslint/restrict-template-expressions, @typescript-eslint/no-unsafe-member-access */
  Object.keys(entryPoints).forEach((chunk) => {
    plugins.push(
      new HtmlWebpackPlugin({
        inject: false,
        filename: `../views/${chunk}.head.html`,
        templateContent: (
          /** @type {{ [option: string]: any; }} */ { htmlWebpackPlugin }
        ) => `${htmlWebpackPlugin.tags.headTags}`,
        chunks: [chunk],
      })
    );
    plugins.push(
      new HtmlWebpackPlugin({
        inject: false,
        filename: `../views/${chunk}.body.html`,
        templateContent: (
          /** @type {{[option: string]: any;}} */ { htmlWebpackPlugin }
        ) => `${htmlWebpackPlugin.tags.bodyTags}`,
        chunks: [chunk],
      })
    );
  });
  /* eslint-enable @typescript-eslint/restrict-template-expressions, @typescript-eslint/no-unsafe-member-access */

  plugins.push(
    new HtmlWebpackPlugin({
      template: `${src}/static.html`,
      filename: `static.html`,
      chunks: ["css/global"],
    })
  );

  return {
    // The current mode, defaults to production
    mode: argv.mode,

    // Used for generating source maps (used for debugging)
    devtool: devtool,

    // The entry points ("location to store": "location to find")
    entry: entryPoints,

    // The location where bundle are stored
    output: {
      path: path.resolve(__dirname, "dist/frontend/public"),
      publicPath: "/",
      filename: "[name].[contenthash].js",
      chunkFilename: "chunk/[id].[contenthash].js",
    },

    resolve: {
      extensions: [
        ".ts",
        ".tsx",
        ".cts",
        ".mts",
        ".js",
        ".jsx",
        ".cjs",
        ".mjs",
        ".css",
        ".scss",
        ".sass",
        ".less",
      ],
    },

    module: {
      rules: [
        {
          test: /\.(c|m)?tsx?$/,
          use: [
            {
              loader: "ts-loader",
              options: {
                configFile: "tsconfig.frontend.json",
              },
            },
          ],
          exclude: /node_modules/,
        },
        {
          test: /\.module\.(sa|sc|c)ss$/,
          use: [
            isDevelopmentMode ? "style-loader" : MiniCssExtractPlugin.loader,
            {
              loader: "css-loader",
              options: {
                modules: true,
                sourceMap: true,
              },
            },
            {
              loader: "sass-loader",
              options: {
                sourceMap: true,
              },
            },
          ],
        },
        {
          test: /\.(sa|sc|c)ss$/,
          exclude: /\.module\.(sa|sc|c)ss$/,
          use: [
            isDevelopmentMode ? "style-loader" : MiniCssExtractPlugin.loader,
            {
              loader: "css-loader",
              options: {
                modules: false,
                sourceMap: true,
              },
            },
            {
              loader: "sass-loader",
              options: {
                sourceMap: true,
              },
            },
          ],
        },
        {
          test: /\.less$/,
          use: [
            isDevelopmentMode ? "style-loader" : MiniCssExtractPlugin.loader,
            {
              loader: "css-loader",
              options: {
                sourceMap: true,
              },
            },
            {
              loader: "less-loader",
              options: {
                sourceMap: true,
              },
            },
          ],
        },
      ],
    },

    plugins: plugins,
  };
};
