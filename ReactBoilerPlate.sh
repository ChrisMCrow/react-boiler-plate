#!/usr/bin/env bash

# get a project name
read -p 'Project name: ' projectName
echo 'Project name is "'$projectName'"'

# if there is no such directory named $projectName
if [ -d ${projectName} ]; then
  echo Directory already exists...
else
  # make a project directory
  echo Making a new directory named $projectName...
  mkdir $projectName
fi

# go to the project directory
cd $projectName

# make README.md file and git initialization
echo Initializing git...
git init

echo Making README file...
touch README.md

touch .gitignore
cat >.gitignore <<EOL
.DS_Store
node_modules/
build/
EOL

# initialize package.json
echo Initializing package.json
touch package.json
cat >package.json <<EOL
{
  "name": "${projectName}",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "start":  "webpack-dev-server",
    "lint": "eslint src/** src/**/**; exit 0",
    "lint-fix": "eslint src/** src/**/** --fix; exit 0"
  },
  "author": "",
  "license": "ISC"
}

EOL
d
echo Installing React and prop types...

# install React, Prop types, and hot loader
npm install react@15.5.4 react-dom@15.5.4 --save
npm install prop-types@15.5.10 --save
npm install react-hot-loader@3.0.0-beta.7 --save-dev

echo Installing Webpack...

# install webpack, webpack development server, and html webpack plugin
npm install webpack@3.4.0 --save-dev
npm install webpack@3.4.0 -g
npm install webpack-dev-server@2.5.0 -g
npm install webpack-dev-server@2.5.0 --save-dev\
npm install html-webpack-plugin@2.29.0 --save-dev

echo Installing Babel...

# install babel
npm install babel-core@6.24.1 babel-loader@7.0.0 babel-preset-es2015@6.24.1 babel-preset-react@6.24.1 --save-dev

# configure webpack
echo Configuring webpack...
touch webpack.config.js
cat >webpack.config.js <<EOL
const webpack = require('webpack');
const { resolve } = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: [
    'react-hot-loader/patch',
    'webpack-dev-server/client?http://localhost:8080',
    'webpack/hot/only-dev-server',
    resolve(__dirname, "src", "index.jsx")
  ],
  output: {
    filename: 'app.bundle.js',
    path: resolve(__dirname, 'build'),
    publicPath: '/'
  },
  resolve: {
    extensions: ['.js', '.jsx']
  },
  devtool: '#source-map',
  devServer: {
    hot: true,
    contentBase: resolve(__dirname, 'build'),
    publicPath: '/'
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        enforce: "pre",
        loader: "eslint-loader",
        exclude: /node_modules/,
        options: {
          emitWarning: true,
          configFile: "./.eslintrc.json"
          }
      },
      {
        test: /\.jsx?$/,
        loader: "babel-loader",
        exclude: /node_modules/,
        options: {
          presets: [
            ["es2015", {"modules": false}],
            "react",
          ],
          plugins: [
            "react-hot-loader/babel",
            "styled-jsx/babel"
          ]
        }
      },
    ],
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NamedModulesPlugin(),
    new HtmlWebpackPlugin({
      template:'template.ejs',
      appMountId: 'react-app-root',
      title: '${projectName}',
      filename: resolve(__dirname, "build", "index.html"),
    }),
  ]
};
EOL

# make src directory and basic files
echo Making the src folder, index.html, main.js, and styles.css files... 
mkdir src
mkdir src/components
touch template.ejs
cat >template.ejs <<EOL
<!DOCTYPE html>
<head>
  <meta charset="utf-8">
  <title><%= htmlWebpackPlugin.options.title %></title>
</head>
  <body>
    <% if (htmlWebpackPlugin.options.appMountId) { %>
      <div id="<%= htmlWebpackPlugin.options.appMountId%>"></div>
    <% } %>
  </body>
</html>
EOL

touch src/index.jsx
cat >src/index.jsx <<EOL
import React from 'react';
import ReactDOM from 'react-dom';
import App from './components/App';
import { AppContainer } from 'react-hot-loader';

const render = (Component) => {
  ReactDOM.render(
    <AppContainer>
      <Component/>
    </AppContainer>,
    document.getElementById('react-app-root')
  );
};

render(App);

/*eslint-disable */
if (module.hot) {
  module.hot.accept('./components/App', () => {
    render(App)
  });
}
/*eslint-enable */
EOL

touch src/components/App.jsx
cat >src/components/App.jsx <<EOL
import React from 'react';
//import PropTypes from 'prop-types';

function App(){
  var styles = {
  };
  return (
    <div style={styles}>
      <style jsx>{\`
        font-family: Helvetica;
      \`}</style>
      ${projectName}
    </div>
  );
}

//App.propTypes = {
//};

export default App;
EOL

# install eslint and its plugins
echo Install eslint and its plugins and loaders...

npm install eslint@4.13.1 -g
npm install eslint@4.13.1 --save-dev

npm install eslint-plugin-react -g
npm install eslint-plugin-react --save-dev

npm install eslint-loader --save-dev

touch .eslintrc.json
cat >.eslintrc.json <<EOL
{
  "env": {
    "browser": true,
    "es6": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaFeatures": {
      "experimentalObjectRestSpread": true,
      "jsx": true
    },
    "sourceType": "module"
  },
  "plugins": [
    "react"
  ],
  "rules": {
    "indent": [
      "error",
      2
    ],
    "linebreak-style": [
      "error",
      "unix"
    ],
    "quotes": [
      "error",
      "single"
    ],
    "semi": [
      "error",
      "always"
    ],
    "react/jsx-uses-vars": 2,
    "react/jsx-uses-react": 2,
    "react/jsx-no-duplicate-props": 2,
    "react/jsx-no-undef": 2,
    "react/no-multi-comp": 2,
    "react/jsx-indent-props": [
        "error",
        2
      ],
    "react/jsx-pascal-case": 2,
    "react/prop-types": 2,
    "react/jsx-indent": [
        "error",
        2
    ],
    "react/jsx-key": 2
  }
}
EOL

npm install --save styled-jsx
