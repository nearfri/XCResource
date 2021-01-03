#!/bin/sh

# 에러가 발생하면 스크립트 종료
set -e

swift run --package-path ../../../ xcresource csv2strings \
    --csv-path ./SampleApp-translation.csv \
    --resources-path ../XCResourceApp
