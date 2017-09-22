# Robocrop frontend

This is an elm app, compiled from `src` into `dist/app.js` which can be done with `make` or more explicitly with `elm-make src/Main.elm --yes --warn --output=dist/app.js`

`make` also syncs files under `static` to `dist` and installs elm packages if `package.json` has been modified.

There is also a script that watches this directory for changes and runs make when any files change, and also runs a web server from `dist`.
