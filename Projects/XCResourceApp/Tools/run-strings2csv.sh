#!/bin/sh

# 에러가 발생하면 스크립트 종료
set -e

swift run --package-path ../../../ xcresource strings2csv \
    --resources-path ../XCResourceApp \
    --development-localization ko \
    --csv-path ./SampleApp-translation.csv \
    --write-bom
