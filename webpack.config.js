let path = require("path");
let webpack = require('webpack');

let bundleTarget = process.env.target === "web" ? "web" : "node";
console.log("Bundle target:", bundleTarget);

let entry = process.env.entry ?? './server.js';
console.log("Entry:", entry);

let hot = process.env.hot === 'true' ? true : false;
console.log("Hot:", hot)

module.exports = {
  entry: hot ? [
    'webpack/hot/poll?1000',
    entry
  ] : entry,
  target: bundleTarget,
  mode: "development",
  devtool: "hidden-source-map",
  externals: {
    ws: "commonjs ws",
    randomcolor: "commonjs randomcolor",
    shortid: "commonjs shortid",
    md5: "commonjs md5",
    chalk: "commonjs chalk",
    gaze: "commonjs gaze",
    ws: "commonjs ws",
    dayjs: "commonjs dayjs",
    "latest-version": "commonjs latest-version",
  },
  output: {
    path: path.resolve(__dirname, "js-out/"),
    filename: "bundle.js",
  },
  plugins: [
    hot ? new webpack.HotModuleReplacementPlugin(): null
  ].filter(x => x != null)
};
