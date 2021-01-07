#!/bin/sh

# 에러가 발생하면 스크립트 종료
set -e

swift run --package-path ../../../ xcresource xcassets2swift \
    --xcassets-path ../XCResourceApp/Assets.xcassets \
    --asset-type image \
    --swift-path ../XCResourceApp/ResourceKeys/ImageKey.swift \
    --swift-type-name ImageKey

swift run --package-path ../../../ xcresource xcassets2swift \
    --xcassets-path ../XCResourceApp/Assets.xcassets \
    --asset-type color \
    --swift-path ../XCResourceApp/ResourceKeys/ColorKey.swift \
    --swift-type-name ColorKey
