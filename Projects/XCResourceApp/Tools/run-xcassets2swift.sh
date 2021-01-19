#!/bin/sh

# 에러가 발생하면 스크립트 종료
set -e

xcrun --sdk macosx swift run --package-path ../../../ xcresource xcassets2swift \
    --xcassets-path ../XCResourceApp/Assets.xcassets \
    --asset-type imageset \
    --swift-path ../XCResourceApp/ResourceKeys/ImageKey.swift \
    --swift-type-name ImageKey

xcrun --sdk macosx swift run --package-path ../../../ xcresource xcassets2swift \
    --xcassets-path ../XCResourceApp/Assets.xcassets \
    --asset-type colorset \
    --swift-path ../XCResourceApp/ResourceKeys/ColorKey.swift \
    --swift-type-name ColorKey
