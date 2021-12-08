#!/bin/zsh

# 에러가 발생하면 스크립트 종료
set -e

XCRESOURCE="xcrun --sdk macosx swift run --package-path ../../../ xcresource"

PROJECT_NAME=XCResourceApp
PROJECT_DIR=../$PROJECT_NAME
RESOURCES_DIR=$PROJECT_DIR
RESOURCEKEYS_DIR=$PROJECT_DIR/ResourceKeys

IMAGEKEY_NAME=ImageKey
COLORKEY_NAME=ColorKey
STRINGKEY_NAME=StringKey
STRINGFORM_NAME=StringForm

IMAGEKEY_FILE=$RESOURCEKEYS_DIR/$IMAGEKEY_NAME.swift
COLORKEY_FILE=$RESOURCEKEYS_DIR/$COLORKEY_NAME.swift
STRINGKEY_FILE=$RESOURCEKEYS_DIR/$STRINGKEY_NAME.swift
STRINGFORM_FILE=$RESOURCEKEYS_DIR/$STRINGFORM_NAME.swift

ASSETS_DIR=$RESOURCES_DIR/Assets.xcassets

CSV_FILE=./$PROJECT_NAME-localizations.csv

# Run xcresource with xcresource.json
eval $XCRESOURCE

# Run xcassets2swift
eval $XCRESOURCE xcassets2swift \
    --xcassets-path $ASSETS_DIR \
    --asset-type imageset \
    --swift-path $IMAGEKEY_FILE \
    --swift-type-name $IMAGEKEY_NAME

eval $XCRESOURCE xcassets2swift \
    --xcassets-path $ASSETS_DIR \
    --asset-type colorset \
    --swift-path $COLORKEY_FILE \
    --swift-type-name $COLORKEY_NAME

# Run swift2strings
eval $XCRESOURCE swift2strings \
    --swift-path $STRINGKEY_FILE \
    --resources-path $RESOURCES_DIR \
    --language ko \
    --value-strategy ko:comment

# Run key2form
eval $XCRESOURCE key2form \
    --key-file-path $STRINGKEY_FILE \
    --form-file-path $STRINGFORM_FILE \
    --form-type-name $STRINGFORM_NAME \
    --issue-reporter xcode

# Run strings2csv
eval $XCRESOURCE strings2csv \
    --resources-path $RESOURCES_DIR \
    --development-language ko \
    --csv-path $CSV_FILE \
    --header-style long-ko \
    --write-bom

# Run csv2strings
# Remove "\r" characters
grep -q '\r' $CSV_FILE && sed -i '' 's/\r//g' $CSV_FILE
eval $XCRESOURCE csv2strings \
    --csv-path $CSV_FILE \
    --header-style long-ko \
    --resources-path $RESOURCES_DIR \
    --empty-encoding "#EMPTY"
