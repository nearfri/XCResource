#!/bin/sh

# 에러가 발생하면 스크립트 종료
set -e

swift run --package-path ../../../ xcresource generate-asset-keys \
    --input-xcassets ../XCResourceApp/Assets.xcassets \
    --asset-type image \
    --key-type-name ImageKey \
    --module-name XCResourceApp \
    --key-decl-file ../XCResourceApp/ResourceKeys/ImageKey.swift \
    --key-list-file ../XCResourceAppTests/ResourceKeys/AllImageKeys.swift

swift run --package-path ../../../ xcresource generate-asset-keys \
    --input-xcassets ../XCResourceApp/Assets.xcassets \
    --asset-type color \
    --key-type-name ColorKey \
    --module-name XCResourceApp \
    --key-decl-file ../XCResourceApp/ResourceKeys/ColorKey.swift \
    --key-list-file ../XCResourceAppTests/ResourceKeys/AllColorKeys.swift
