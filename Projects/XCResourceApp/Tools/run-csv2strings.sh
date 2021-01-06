#!/bin/sh

# 에러가 발생하면 스크립트 종료
set -e

CSV_PATH="SampleApp-translation.csv"

# "\r" 문자를 지운다.
grep -q '\r' $CSV_PATH && sed -i '' 's/\r//g' $CSV_PATH

swift run --package-path ../../../ xcresource csv2strings \
    --csv-path $CSV_PATH \
    --header-style long-ko \
    --resources-path ../XCResourceApp
