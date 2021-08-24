#!/usr/bin/env sh

source ./scripts/common.sh

./scripts/build.sh

hugo server --noHTTPCache --disableFastRender --gc
