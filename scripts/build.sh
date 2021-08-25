source ./scripts/common.sh
#!/usr/bin/env sh

rm -rf "$STATIC_BUILD"
rm -rf "$OUTPUT_DIR"

mkdir -p "$STATIC_BUILD"

mkdir -p "$STATIC_SRC/img"
cp -r "$STATIC_SRC/img/*" "$STATIC_BUILD/img"

mkdir -p "$STATIC_SRC/js"
cp -r "$STATIC_SRC/js/*" "$STATIC_BUILD/js"

mkdir -p "$STATIC_SRC/css"
cp -r "$STATIC_SRC/css/*" "$STATIC_BUILD/css"
cp -r "$BASEDIR/node_modules/@fortawesome/fontawesome-free/css/all.min.css" "$STATIC_BUILD/css/font-awesome.css"
hugo gen chromastyles --style=monokai > "$STATIC_BUILD/css/highlight.css"

mkdir -p "$STATIC_SRC/scss"
cp -r "$STATIC_SRC/scss/*" "$STATIC_BUILD/scss"


hugo -vDEF --gc $@
