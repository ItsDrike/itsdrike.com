#!/usr/bin/env bash
source ./scripts/common.sh

rm -rf "$STATIC_BUILD"
rm -rf "$OUTPUT_DIR"
rm -rf "$BASEDIR/resources"

mkdir -p "$STATIC_BUILD"

mkdir -p "$STATIC_BUILD/img"
cp -r "$STATIC_SRC/img"/* "$STATIC_BUILD/img"

mkdir -p "$STATIC_BUILD/js"
cp -r "$STATIC_SRC/js"/* "$STATIC_BUILD/js"
cp "$BASEDIR/node_modules/jquery/dist/jquery.min.js" "$STATIC_BUILD/js/jquery.min.js"
cp "$BASEDIR/node_modules/bootstrap/dist/js/bootstrap.bundle.min.js" "$STATIC_BUILD/js/bootstrap.min.js"

mkdir -p "$STATIC_BUILD/css"
#cp -r "$STATIC_SRC/css"/* "$STATIC_BUILD/css"
cp -r "$BASEDIR/node_modules/@fortawesome/fontawesome-free/css/all.min.css" "$STATIC_BUILD/css/font-awesome.css"

mkdir -p "$STATIC_BUILD/scss"
cp -r "$STATIC_SRC/scss"/* "$STATIC_BUILD/scss"

cp -r "$BASEDIR/node_modules/@fortawesome/fontawesome-free/webfonts" "$STATIC_BUILD"

hugo -vDEF --gc $@
