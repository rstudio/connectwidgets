const path = require('path');

module.exports = {
  entry: {
    rsc_grid: path.join(__dirname, 'srcjs/GridView', 'index.js'),
    rsc_card: path.join(__dirname, 'srcjs/CardView', 'index.js'),
    rsc_filter: path.join(__dirname, 'srcjs/Filter', 'index.js'),
    rsc_search: path.join(__dirname, 'srcjs/Search', 'index.js'),
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
                plugins: [require('autoprefixer')]
              }
            }
          }
        ]
      },
      {
        test: /\.(png|svg|jpg|jpeg|gif)$/i,
        loader: 'url-loader'
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
