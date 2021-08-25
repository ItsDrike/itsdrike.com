# My personal website

[![AGPL](https://img.shields.io/badge/Licensed%20under-AGPL-red.svg?style=flat-square)](./LICENSE)
[![Validation](https://github.com/ItsDrike/portfolio/actions/workflows/validation.yaml/badge.svg)](https://github.com/ItsDrike/portfolio/actions/workflows/validation.yaml)

This is the source code for my personal portfolio, hosted on [my website](http://itsdrike.com)


## Building the website

The website is built using [hugo](https://gohugo.io/), but you will also need `npm` for [Bootstrap SASS](https://getbootstrap.com/docs/5.0/customize/sass/).
The `npm` dependencies are listed in [`package.json`](./package.json) and can be installed simply by running `npm install`.

After all NPM requirements are satisfied, to build the static webpage, run [`./scripts/build.sh`](./scripts/build.sh), which will create a `./public` directory.
This directory will contain all static files and can be used as a location for the file server. You can also use [`./scripts/server.sh`](./scripts/server.sh), which
will start the server directly with hugo. By default, this will use `http://localhost:1313`.
