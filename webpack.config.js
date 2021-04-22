const path = require('path');

module.exports = {
  entry: {
    rscgrid: path.join(__dirname, 'srcjs/grid', 'index.js'),
    rsccard: path.join(__dirname, 'srcjs/card', 'index.js'),
    rscfilter: path.join(__dirname, 'srcjs/filter', 'index.js'),
    rscsearch: path.join(__dirname, 'srcjs/search', 'index.js'),
  },
  output: {
    filename: '[name].js',
    path: path.join(__dirname, 'inst', 'htmlwidgets')
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env']
          }
        }
      },
      {
        test: /\.(css|scss)$/,
        use: [
          'style-loader',
          'css-loader',
          'sass-loader',
          {
            loader: 'postcss-loader',
            options: {
              postcssOptions: {
                plugins: [require('autoprefixer'), require('cssnano')]
              }
            }
          }
        ]
      }
    ]
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './srcjs'),
    },
    extensions: ['.js', '.jsx'],
  },
  externals: {
    'react': 'window.React',
    'react-dom': 'window.ReactDOM',
    'reactR': 'window.reactR'
  },
  devtool: 'source-map'
}
