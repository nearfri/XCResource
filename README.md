# XCResource
[![Swift](https://github.com/nearfri/XCResource/workflows/Swift/badge.svg)](https://github.com/nearfri/XCResource/actions?query=workflow%3ASwift)
[![codecov](https://codecov.io/gh/nearfri/XCResource/branch/main/graph/badge.svg?token=DWKDFE0O2A)](https://codecov.io/gh/nearfri/XCResource)

XCResource는 Xcode 프로젝트에서 리소스(문자열, 폰트, 파일 등)를 안전하고 효율적으로 관리할 수 있는 도구입니다.  
자동 코드 생성을 통해 오타와 런타임 오류를 줄여줍니다.

## 특징

### 1. 리소스 코드 생성
- **문자열, 폰트, 파일 리소스**에 대해 타입 안전한 Swift 코드를 생성합니다.

### 2. 유연한 설정 및 통합
- Swift Package Manager 지원으로 의존성 관리가 간편합니다.
- 설정 파일을 통해 원하는 경로의 리소스만 코드로 생성합니다.
- Swift Package Plugin을 사용해 간단하게 실행할 수 있습니다.

## 설치 방법

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/nearfri/XCResource.git", from: "0.11.4"),
    // 혹은
    .package(url: "https://github.com/nearfri/XCResource-plugin.git", from: "0.11.4"),
],
```

`XCResource`는 전체 소스 코드를 포함하기 때문에 플러그인만 포함하는 [`XCResource-plugin`](https://github.com/nearfri/XCResource-plugin.git)을 사용하길 추천합니다. 

## 빠른 시작

### 1. 다국어 문자열 관리
https://github.com/nearfri/XCResource/assets/323940/8f7c0a85-f4fb-4c96-b6cb-0ed2d0f72698

#### 설정 파일 작성 (`xcresource.json`)  
```json
{
    "commands": [
        {
            "commandName": "xcstrings2swift",
            "catalogPath": "Sources/Resources/Resources/Localizable.xcstrings",
            "bundle": "at-url:Bundle.module.bundleURL",
            "swiftPath": "Sources/Resources/Keys/LocalizedStringResource+.swift"
        }
    ]
}
```

#### 생성된 코드 예시
```swift
public extension LocalizedStringResource {
    /// \"\\(param1)\" will be deleted.\
    /// This action cannot be undone.
    static func alertDeleteFile(_ param1: String) -> Self {
        .init("alert_delete_file",
              defaultValue: """
                \"\(param1)\" will be deleted.
                This action cannot be undone.
                """,
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Done
    static var commonDone: Self {
        .init("common_done",
              defaultValue: "Done",
              bundle: .atURL(Bundle.module.bundleURL))
    }
}
```
*(다국어 키와 함수 시그니처가 동일하다면 함수명이나 파라미터명은 변경 가능합니다.)*

#### 코드 사용 예시
```swift
let greeting = String(localized: .commonDone)
```

### 2. 폰트 코드 생성
https://github.com/nearfri/XCResource/assets/323940/aada31e4-9b04-4467-b8bb-0f5786171c45

#### 설정 파일 작성 (`xcresource.json`)  
```json
{
    "commands": [
        {
            "commandName": "fonts2swift",
            "resourcesPath": "Sources/Resources/Resources",
            "swiftPath": "Sources/Resources/Keys/FontResource.swift",
            "keyTypeName": "FontResource",
            "keyListName": "all",
            "generatesLatinKey": true,
            "stripsCombiningMarksFromKey": true,
            "preservesRelativePath": true,
            "bundle": "Bundle.module",
            "accessLevel": "public"
        }
    ]
}
```

#### 생성된 코드 예시  
```swift
public struct FontResource: Hashable, Sendable {
    public let fontName: String
    public let familyName: String
    public let style: String
    public let relativePath: String
    public let bundle: Bundle
    ...
}

public extension FontResource {
    static let all: [FontResource] = [
        // Cambria
        .cambriaRegular,
        
        // Open Sans
        .openSansBold,
    ]
}

public extension FontResource {
    // MARK: Cambria
    
    static let cambriaRegular: FontResource = .init(
        fontName: "Cambria",
        familyName: "Cambria",
        style: "Regular",
        relativePath: "Fonts/Cambria.ttc",
        bundle: Bundle.module)
    
    // MARK: Open Sans
    
    static let openSansBold: FontResource = .init(
        fontName: "OpenSans-Bold",
        familyName: "Open Sans",
        style: "Bold",
        relativePath: "Fonts/OpenSans/OpenSans-Bold.ttf",
        bundle: Bundle.module)
}
```

#### 코드 사용 예시  
```swift
Font.custom(.openSansBold, size: 16)
```

### 3. 파일 코드 생성

#### 설정 파일 작성 (`xcresource.json`)  
```json
{
    "commands": [
        {
            "commandName": "files2swift",
            "resourcesPath": "Sources/Resources/Resources/Lotties",
            "filePattern": "(?i)\\.json$",
            "swiftPath": "Sources/Resources/Keys/LottieResource.swift",
            "keyTypeName": "LottieResource",
            "preservesRelativePath": true,
            "relativePathPrefix": "Lotties",
            "bundle": "Bundle.module",
            "accessLevel": "public"
        }
    ]
}
```

#### 생성된 코드 예시
```swift
public struct LottieResource: Hashable, Sendable {
    public let relativePath: String
    public let bundle: Bundle
    ...
}

extension LottieResource {
    public static let hello: LottieResource = .init(
        relativePath: "Lotties/hello.json",
        bundle: Bundle.module)
}
```

#### 코드 사용 예시
```swift
LottieView(.hello)
```

## 제공되는 커맨드
| 명령어 | 설명 |
|------|-----|
| `xcstrings2swift` | `.xcstrings` 파일을 분석하여 코드 생성 |
| `fonts2swift` | 폰트 폴더를 스캔하여 코드 생성 |
| `files2swift` | 파일 폴더를 스캔하여 코드 생성 |
| `xcassets2swift` | `.xcassets` 폴더를 스캔하여 코드 생성 |

## 라이선스
XCResource는 MIT 라이선스에 따라 배포됩니다. 자세한 내용은 LICENSE를 참조하십시오.
