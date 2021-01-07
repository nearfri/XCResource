#!/bin/sh

# 에러가 발생하면 스크립트 종료
set -e

swift run --package-path ../../../ xcresource swift2strings \
    --swift-path ../XCResourceApp/ResourceKeys/StringKey.swift \
    --resources-path ../XCResourceApp \
    --value-strategy ko:comment \
    --sort-by-key
