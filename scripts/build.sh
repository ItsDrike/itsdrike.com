source ./scripts/common.sh
#!/usr/bin/env sh

rm -rf "$STATIC_BUILD"
rm -rf "$OUTPUT_DIR"

mkdir -p "$STATIC_BUILD"

cp -r "$STATIC_SRC/img" "$STATIC_BUILD/img"
cp -r "$STATIC_SRC/js" "$STATIC_BUILD/js"
cp -r "$STATIC_SRC/css" "$STATIC_BUILD/css"
cp -r "$STATIC_SRC/scss" "$STATIC_BUILD/scss"

hugo gen chromastyles --style=monokai > "$STATIC_BUILD/css/highlight.css"

hugo -vDEF --gc $@
