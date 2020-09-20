import Foundation
import ArgumentParser

// argument 파싱
// v xcasset 폴더 뒤져서 모델화
// 필요한 타입들만 필터링해서 코드로 생성
//   모듈 이름과 테스트 파일 argument 있으면 테스트 파일에 모든 키 추출

// generate-assetkeys -i Assets.xcassets -i Assets2.xcassets -o ImageKey.swift
let inputFiles: [String] = []
let outputFile: String = ""
let inputURL: URL = URL(fileURLWithPath: "/")
let outputURL: URL = URL(fileURLWithPath: "/")
