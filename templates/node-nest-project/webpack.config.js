import path from "path";
import url from "url";
import webpack from "webpack";
import HtmlWebpackPlugin from "html-webpack-plugin";
import MiniCssExtractPlugin from "mini-css-extract-plugin";

const __filename = url.fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);


const src = path.resolve(__dirname, 'src/frontend/static');

const entryPoints = {
  "css/global": [`${src}/css/global`],
  "js/app": [`${src}/js/app`],
  "module/foo": [`${src}/module/foo`],
  // "other output points" : ["other entry point"]
};


export default (env, argv) => {

  const isDevelopmentMode = (argv.mode === "development");

  // Locally, we want robust source-maps. However, in production, we want something
  // that can help with debugging without giving away all of the source-code. This
  // production setting will give us proper file-names and line-numbers for debugging;
  // but, without actually providing any code content.
  const devtool = isDevelopmentMode
    ? "eval-source-map"
    : "nosources-source-map";

  return ({
    // The current mode, defaults to production
    mode: argv.mode,

    // Used for generating source maps (used for debugging)
    devtool: devtool,

    // The entry points ("location to store": "location to find")
    entry: entryPoints,

    // The location where bundle are stored
    output: {
      path: path.resolve(__dirname, 'dist/frontend'),
      publicPath: '/',
      filename: "static/[name].[contenthash].js",
      chunkFilename: 'static/chunk/[id].[contenthash].js'
    },

    resolve: {
      extensions: [".tsx", ".ts", ".js", ".scss", ".sass", ".css"],
    },

    module: {
      rules: [
        {
          test: /\.tsx?$/,
          use: [
            {
              loader: 'ts-loader',
              options: {
                configFile: 'tsconfig.frontend.json'
              }
            }
          ],
          exclude: /node_modules/,
        },
        {
          test: /\.module\.(sa|sc|c)ss$/,
          use: [
            isDevelopmentMode ? 'style-loader' : MiniCssExtractPlugin.loader,
            {
              loader: 'css-loader',
              options: {
                modules: true,
                sourceMap: true
              }
            },
            {
              loader: 'sass-loader',
              options: {
                sourceMap: true
              }
            }
          ]
        },
        {
          test: /\.(sa|sc|c)ss$/,
          exclude: /\.module\.(sa|sc|c)ss$/,
          use: [
            isDevelopmentMode ? 'style-loader' : MiniCssExtractPlugin.loader,
            {
              loader: 'css-loader',
              options: {
                modules: false,
                sourceMap: true
              }
            },
            {
              loader: 'sass-loader',
              options: {
                sourceMap: true
              }
            }
          ]
        }
      ],
    },

    plugins: [
      new MiniCssExtractPlugin({
        filename: 'static/[name].[contenthash].css',
        chunkFilename: 'static/chunk/[id].[contenthash].css'
      }),
    ].concat(Object.keys(entryPoints).map((chunk) =>
      new HtmlWebpackPlugin({
        inject: false,
        filename: `views/${chunk}.head.html`,
        templateContent: ({htmlWebpackPlugin}) => `${htmlWebpackPlugin.tags.headTags}`,
        chunks: [chunk]
      })
    )).concat(Object.keys(entryPoints).map((chunk) =>
      new HtmlWebpackPlugin({
        inject: false,
        filename: `views/${chunk}.body.html`,
        templateContent: ({htmlWebpackPlugin}) => `${htmlWebpackPlugin.tags.bodyTags}`,
        chunks: [chunk]
      })
    ))
  });
};
