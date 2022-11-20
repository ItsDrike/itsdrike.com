# My personal website

[![AGPL](https://img.shields.io/badge/Licensed%20under-AGPL-red.svg?style=flat-square)](./LICENSE)

This is the source code for my personal website, hosted on <https://itsdrike.com>


## Building the website

The website is built using [hugo](https://gohugo.io/), but you will also need `npm`, since it provides easy way to version control the needed packages. These include things such as [Bootstrap SASS](https://getbootstrap.com/docs/5.0/customize/sass/), [Font Awesome (Free)](https://fontawesome.com/) and [JQuery](https://jquery.com/).

After all NPM requirements are satisfied, you will also need to synchronize to git submodules, to obtain additional themes.

To then build the static webpage using hugo, run [`./scripts/build.sh`](./scripts/build.sh),
which will create a `./public` directory, with all static files and can be hosted with a file server (such as nginx, or
apache).

If you want to test out the webpage locally, or if you prefer to stick purely with hugo, even for deployment, instead
of building the webpage, you can use hugo's server functionality and run the [`scripts/server.sh`](./scripts/server.sh)
script instead of the build script. By default, this will host the server on <http://localhost:1313>, but you can pass
hugo server arguments to the script, just like you would with running bare `hugo server`. For example:
```
$ ./scripts/server.sh --bind 0.0.0.0 --port 80 --baseURL https://itsdrike.com/
```

## Docker

Another way to deploy the webpage is to use the automatically built docker container, which you can find [here](https://github.com/ItsDrike/itsdrike.com/pkgs/container/web). This container is always built from latest version in the main branch, and to get it, you can simply run
```
$ sudo docker run -p 8080:80 ghcr.io/itsdrike/web
```

Which will expose the web on port 8080 (see it at http://127.0.0.1:8080)
