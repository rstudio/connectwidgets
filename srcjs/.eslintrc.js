module.exports = {
  parser: "@babel/eslint-parser",
  extends: [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
    "plugin:jest/recommended",
    "plugin:jsx-a11y/recommended"
  ],
  env: {
    browser: true,
    commonjs: true,
    jest: true,
    es6: true
  },
  globals: {
    jest: true,
    expect: true,
    React: "readonly",
    crosstalk: "readonly",
    HTMLWidgets: "readonly",
    dayjs: "readonly",
    dayjs_plugin_localizedFormat: "readonly"
  },
  plugins: ["react", "jsx-a11y", "jest"],
  settings: {
    "react": {
      "version": "detect"
    }
  }
}
