// The base directory that we want to use
const baseDirectory = "src";

export default {
  // The current mode, defaults to production
  mode: "development",

  // Used for generating source maps (used for debugging)
  devtool: "eval-source-map",

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
};
