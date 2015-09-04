var fs = require('fs');
var path = require('path');
var webpack = require('webpack');

var babelrc = fs.readFileSync('./.babelrc');
var babelLoaderQuery = {};

try {
  babelLoaderQuery = JSON.parse(babelrc);
} catch (err) {
  console.error('ERROR: Error parsing your .babelrc.');
  console.error(err);
}

babelLoaderQuery.plugins = babelLoaderQuery.plugins || [];
babelLoaderQuery.plugins.push('react-transform');
babelLoaderQuery.extra = babelLoaderQuery.extra || {};
babelLoaderQuery.extra['react-transform'] = {
  transforms: [{
    transform: 'react-transform-hmr',
    imports: ['react'],
    locals: ['module']
  }]
};

module.exports = {
  devtool: 'cheap-module-eval-source-map',
  entry: [
    'webpack-dev-server/client?http://localhost:50000',
    'webpack/hot/only-dev-server',
    './src/index'
  ],
  output: {
    path: path.join(__dirname, 'debug'),
    filename: 'index.js',
    publicPath: 'http://localhost:50000/'
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin()
  ],
  module: {
    loaders: [
      { test: /\.js$/, exclude: /node_modules/, loaders: ['babel?' + JSON.stringify(babelLoaderQuery)] },
      //{ test: /\.js$/, exclude: /node_modules/, loaders: ['babel?' + JSON.stringify(babelLoaderQuery), 'eslint-loader'] },
      { test: /\.scss$/, loader: 'style!css!sass' }
    ]
  }
};
