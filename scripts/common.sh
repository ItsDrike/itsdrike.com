#!/usr/bin/env bash

BASEDIR="$PWD"
export OUTPUT_DIR="$BASEDIR/public"
export STATIC_SRC="$BASEDIR/static/src"
export STATIC_BUILD="$BASEDIR/static/build"

if [[ -f "$BASEDIR/.env" ]]; then
    export $(cat "$BASEDIR/.env" | xargs)
fi

NODE_BIN="$BASEDIR/node_modules/.bin"
export PATH="$NODE_BIN:$PATH"
