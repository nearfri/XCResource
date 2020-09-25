#!/bin/sh

swift run --package-path ../../../ generate-asset-keys \
    --input-xcassets ../ResourceKeyApp/Assets.xcassets \
    --asset-type image \
    --key-type-name ImageKey \
    --module-name ResourceKeyApp \
    --key-decl-file ../ResourceKeyApp/ResourceKey/ImageKey.swift \
    --key-list-file ../ResourceKeyAppTests/ResourceKey/AllImageKeys.swift

swift run --package-path ../../../ generate-asset-keys \
    --input-xcassets ../ResourceKeyApp/Assets.xcassets \
    --asset-type color \
    --key-type-name ColorKey \
    --module-name ResourceKeyApp \
    --key-decl-file ../ResourceKeyApp/ResourceKey/ColorKey.swift \
    --key-list-file ../ResourceKeyAppTests/ResourceKey/AllColorKeys.swift
