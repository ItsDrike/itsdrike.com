# My personal website

[![AGPL](https://img.shields.io/badge/Licensed%20under-AGPL-red.svg?style=flat-square)](./LICENSE)

This is the source code for my personal website, hosted on <https://itsdrike.com>


## Building the website

The website is built using [hugo](https://gohugo.io/), but you will also need `npm`, since it provides easy way to version control the needed packages. These include things such as [Bootstrap SASS](https://getbootstrap.com/docs/5.0/customize/sass/), [Font Awesome (Free)](https://fontawesome.com/) and [JQuery](https://jquery.com/).

After all NPM requirements are satisfied, to build the static webpage and hugo is installed, run [`./scripts/build.sh`](./scripts/build.sh), 
which will create a `./public` directory, which will contain all static files and can be used as a location for the file server. 

You can then use any file server of your liking to make the webpage available, if you want to stick to hugo, you can use a custom script, that runs the build script automatically and then starts the hugo server for you: [`scripts/server.sh`](./scripts/server.sh). By default, this will use <http://localhost:1313>, but you can pass hugo server arguments just like you would normally, so you can do: 
```
$ ./scripts/server.sh --bind 0.0.0.0 --port 80 --baseURL https://itsdrike.com/
```
