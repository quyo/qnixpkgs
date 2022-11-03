import path from "path";
import url from "url";
import webpack from "webpack";
import HtmlWebpackPlugin from "html-webpack-plugin";

const __filename = url.fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);


export default (env, argv) => {

  var isDevelopmentMode = (argv.mode === "development");

  // Locally, we want robust source-maps. However, in production, we want something
  // that can help with debugging without giving away all of the source-code. This
  // production setting will give us proper file-names and line-numbers for debugging;
  // but, without actually providing any code content.
  var devtool = isDevelopmentMode
    ? "eval-source-map"
    : "nosources-source-map";

  return ({
    // The current mode, defaults to production
    mode: argv.mode,

    // Used for generating source maps (used for debugging)
    devtool: devtool,

    // The entry points ("location to store": "location to find")
    entry: {
      "static/js/bundle": ["./src/frontend/static/js/app"],      
       // "other output points" : ["other entry point"] 
    },

    // The location where bundle are stored
    output: {
      path: path.resolve(__dirname, 'dist/frontend'),
      publicPath: '/',
      filename: "[name].[contenthash].js",
    },

    resolve: {
      extensions: [".tsx", ".ts", ".js"],
    },

    module: {
      rules: [
        // Using the ts-loader module
        {
          test: /\.tsx?$/,
          use: "ts-loader",
          exclude: /node_modules/,
        },
      ],
    },

    plugins: [
      new HtmlWebpackPlugin({
        template: "!!raw-loader!./src/frontend/views/layout.ejs",
        filename: 'views/layout.ejs',
        publicPath: '/',
      })
    ],

  });
};
