const webpack = require('webpack');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  entry: {
    main: [
      './assets/javascripts/site.js',
      './assets/stylesheets/site.css.scss',
    ],
  },

  output: {
    path: __dirname + '/.tmp/dist',
    filename: 'assets/javascripts/site.js',
  },

  module: {
    rules: [
      {
        enforce: "pre",
        test: /\.scss$/,
        exclude: /node_modules|\.tmp|vendor/,
        loader: 'import-glob-loader',
      },
      {
        test: /\.js?$/,
        loader: "babel-loader",
        exclude: /node_modules/
      },
      {
        test: /\.scss$/,
        exclude: /node_modules|\.tmp|vendor/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
          },
          'css-loader',
          'postcss-loader',
          'sass-loader',
        ]
      }
    ]
  },

  plugins: [
    new webpack.LoaderOptionsPlugin({debug: true}),
    new CleanWebpackPlugin(),
    new MiniCssExtractPlugin({
      filename: 'assets/stylesheets/site.css'
    }),
  ]
};
