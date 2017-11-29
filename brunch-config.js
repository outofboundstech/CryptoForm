// See http://brunch.io for documentation.
module.exports = {
  files: {
    javascripts: {joinTo: 'app.js'},
    stylesheets: {joinTo: 'styles.css'},
  },
  conventions: {
    ignored: [/^app\/elm\/elm-stuff/]
  },
  plugins: {
    elmBrunch: {
        // Set to path where `elm-make` is located, relative to `elmFolder` (optional)
        // executablePath: '../../node_modules/elm/binwrappers',

        // Set to path where elm-package.json is located, defaults to project root (optional)
        // if your elm files are not in /app then make sure to configure paths.watched in main brunch config
        elmFolder: 'app/elm',

        // Set to the elm file(s) containing your "main" function
        // `elm make` handles all elm dependencies (required)
        // relative to `elmFolder`
        mainModules: ['Main.elm'],

        // Defaults to 'js/' folder in paths.public (optional)
        outputFolder: 'vendor',

        // If specified, all mainModules will be compiled to a single file (optional and merged with outputFolder)
        outputFile: 'app.js',

        // optional: add some parameters that are passed to elm-make
        makeParameters : ['--warn']
      }
  }
}
