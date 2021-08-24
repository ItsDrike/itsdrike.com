#!/usr/bin/env sh

BASEDIR="$PWD"
OUTPUT_DIR="$BASEDIR/public"
STATIC_SRC="$BASEDIR/static/src"
STATIC_BUILD="$BASEDIR/static/build"

[[ -f "$BASEDIR/.env" ]] && export $(cat "$BASEDIR/.env" | xargs)
