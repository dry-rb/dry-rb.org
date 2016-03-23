var webpack = require('webpack');
var path = require('path');
var Clean = require('clean-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var autoprefixer = require('autoprefixer')

module.exports = {
  debug: true,

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
    preLoaders: [{
      test: /\.scss$/,
      exclude: /node_modules|\.tmp|vendor/,
      loader: 'import-glob',
    }],

    loaders: [
      { test: /\.js?$/, loader: "babel", exclude: /node_modules/ },
      { test: /\.scss$/, exclude: /node_modules|\.tmp|vendor/,
        loader: ExtractTextPlugin.extract('css!postcss-loader!sass-loader') }
    ]
  },

  postcss: function () {
    return [autoprefixer];
  },

  plugins: [
    new Clean(['.tmp']),
    new ExtractTextPlugin('assets/stylesheets/site.css', { allChunks: true })
  ]
};
