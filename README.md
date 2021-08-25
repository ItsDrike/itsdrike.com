# My personal website

[![AGPL](https://img.shields.io/badge/Licensed%20under-AGPL-red.svg?style=flat-square)](./LICENSE)
[![Validation](https://github.com/ItsDrike/portfolio/actions/workflows/validation.yaml/badge.svg)](https://github.com/ItsDrike/portfolio/actions/workflows/validation.yaml)

This is the source code for my personal portfolio, hosted on [my website](http://itsdrike.com)


## Building the website

The website is built using [hugo](https://gohugo.io/), but you will also need `npm`.
`npm` is necessary for the ease of version control it provides for the packages we need. These include things such as:
- [Bootstrap SASS](https://getbootstrap.com/docs/5.0/customize/sass/) 
- [Font Awesome (Free)](https://fontawesome.com/).

All `npm` dependencies are listed in [`package.json`](./package.json) and can be installed simply by running `npm install`.

After all NPM requirements are satisfied, to build the static webpage and `hugo` is installed, run [`./scripts/build.sh`](./scripts/build.sh), 
which will create a `./public` directory. This directory will contain all static files and can be used as a location for the file server. 

You can then use any file server of your liking to make the webpage available, if you want to stick to hugo, you can also use
[`scripts/server.sh`](./scripts/server.sh), however using this can be a bit slower than using some other tools.
If using the script, it will start the server directly with hugo on `http://localhost:1313`.
