#!/bin/sh

# 에러가 발생하면 스크립트 종료
set -e

swift run --package-path ../../../ generate-keylist \
    --type-name StringKey \
    --module-name ResourceKeyApp \
    --input-file ../ResourceKeyApp/ResourceKey/StringKey.swift \
    --output-file ../ResourceKeyAppTests/ResourceKey/AllStringKeys.swift
