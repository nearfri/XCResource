#!/bin/sh

# 에러가 발생하면 스크립트 종료
set -e

xcrun --sdk macosx swift run --package-path ../../../ xcresource key2form \
    --key-path ../XCResourceApp/ResourceKeys/StringKey.swift \
    --form-path ../XCResourceApp/ResourceKeys/StringForm.swift \
    --form-type-name StringForm \
    --issue-reporter xcode
