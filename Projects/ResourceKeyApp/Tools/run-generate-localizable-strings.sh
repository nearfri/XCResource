#!/bin/sh

# 에러가 발생하면 스크립트 종료
set -e

swift run --package-path ../../../ generate-localizable-strings \
    --input-source ../ResourceKeyApp/ResourceKey/StringKey.swift \
    --resources ../ResourceKeyApp \
    --value-strategy ko:comment \
    --sort-by-key
