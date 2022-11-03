import webpack from "webpack";

// The base directory that we want to use
const baseDirectory = "src";

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
      "public/js/app": [`./${baseDirectory}/public/ts/app`],
       // "other output points" : ["other entry point"] 
    },

    // Using the ts-loader module
    module: {
      rules: [
        {
          test: /\.tsx?$/,
          use: "ts-loader",
          exclude: /node_modules/,
        },
      ],
    },

    resolve: {
      extensions: [".tsx", ".ts", ".js"],
    },

    // The location where bundle are stored
    output: {
      filename: "[name].js",
    },
  });

};
