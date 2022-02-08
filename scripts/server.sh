#!/usr/bin/env bash

source ./scripts/common.sh

./scripts/build.sh

hugo server --noHTTPCache --disableFastRender --gc $@
