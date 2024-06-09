# XCResource
[![Swift](https://github.com/nearfri/XCResource/workflows/Swift/badge.svg)](https://github.com/nearfri/XCResource/actions?query=workflow%3ASwift)
[![codecov](https://codecov.io/gh/nearfri/XCResource/branch/main/graph/badge.svg?token=DWKDFE0O2A)](https://codecov.io/gh/nearfri/XCResource)

XCResource는 xcassets 리소스 로딩과 다국어 지원을 도와주는 커맨드라인 툴입니다.

이를 이용해 이미지, 컬러, 다국어 문자열을 쉽게 생성할 수 있습니다:
```swift
let image = UIImage.named(.settings)
let color = UIColor.named(.coralPink)
let font = UIFont(.openSans_bold, size: 12)
let string = String(localized: .done)
let text = String(localized: .alert_delete_file(named: filename))
```

## 제공기능
`xcresource`는 다음의 하위 커맨드를 가지고 있습니다:
- `xcassets2swift`: xcassets을 위한 Swift 코드를 생성합니다.
- `fonts2swift`: font를 위한 Swift 코드를 생성합니다.
- `xcstrings2swift`: xcstrings 파일로 `LocalizedStringResource` 코드를 생성합니다.
- `strings2swift`: strings 파일로 Swift enum을 생성합니다.
- `swift2strings`: Swift enum으로 strings 파일을 생성합니다.
- `key2form`: Swift enum으로 format string 코드를 생성합니다.
- `strings2csv`: strings 파일로 CSV 파일을 생성합니다.
- `csv2strings`: CSV 파일로 strings 파일을 생성합니다.
- `init`: Manifest 파일을 생성합니다. 
- `run (default)`: Manifest 파일에 나열된 하위 커맨드들을 실행합니다.

## 설치
### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/nearfri/XCResource-plugin", from: "0.10.1"),
],
```

## 사용 예제

### xcassets 이미지 로딩하기
https://github.com/nearfri/XCResource/assets/323940/1244845a-dea1-403c-ae5e-d2a37d24c14b

`xcresource.json`에 아래와 같은 커맨드를 추가하고 `RunXCResource` 플러그인을 실행합니다:
```json
{
    "commands": [
        {
            "commandName": "xcassets2swift",
            "xcassetsPaths": [
                "Sources/Resource/Resources/Assets.xcassets"
            ],
            "assetTypes": ["imageset"],
            "swiftPath": "Sources/Resource/Keys/ImageKey.swift",
            "keyTypeName": "ImageKey",
            "accessLevel": "public"
        }
    ]
}
```

아래와 같은 코드가 생성됩니다:
```swift
struct ImageKey: ExpressibleByStringLiteral, Hashable {
    var rawValue: String
    
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    init(stringLiteral value: String) {
        self.rawValue = value
    }
}

// MARK: - Assets.xcassets

extension ImageKey {
    // MARK: Places
    static let places_authArrow: ImageKey = "Places/authArrow"
    static let places_authClose: ImageKey = "Places/authClose"
    
    // MARK: Settings
    static let settings: ImageKey = "settings"
    static let settingsAppearance: ImageKey = "settingsAppearance"
    ...
```

`UIImage`에 생성자를 추가해줍니다:
```swift
extension UIImage {
    static func named(_ key: ImageKey) -> UIImage {
        return UIImage(named: key.rawValue, in: .module, compatibleWith: nil)!
    }
}
```

이제 자동완성과 함께 이미지를 생성할 수 있습니다:
```swift
imageView.image = .named(.settings)
```

### 커스텀 폰트 로딩하기
https://github.com/nearfri/XCResource/assets/323940/aada31e4-9b04-4467-b8bb-0f5786171c45

`xcresource.json`에 아래와 같은 커맨드를 추가하고 `RunXCResource` 플러그인을 실행합니다:
```json
{
    "commands": [
        {
            "commandName": "fonts2swift",
            "fontsPath": "Sources/Resource/Resources/Fonts",
            "swiftPath": "Sources/Resource/Keys/FontResource.swift",
            "keyTypeName": "FontResource",
            "accessLevel": "public"
        }
    ]
}
```

아래와 같은 코드가 생성됩니다:
```swift
public struct FontResource: Hashable {
    public var fontName: String
    public var familyName: String
    public var style: String
    public var path: String
    
    public init(fontName: String, familyName: String, style: String, path: String) {
        self.fontName = fontName
        self.familyName = familyName
        self.style = style
        self.path = path
    }
}

public extension FontResource {
    static let all: [FontResource] = [
        // Open Sans
        .openSans_bold,
        .openSans_regular,
    ]
}

public extension FontResource {
    // MARK: Open Sans
    
    static let openSans_bold: FontResource = .init(
        fontName: "OpenSans-Bold",
        familyName: "Open Sans",
        style: "Bold",
        path: "OpenSans/OpenSans-Bold.ttf")
    
    ...
```

`UIFont`에 생성자를 추가해줍니다:
```swift
extension UIFont {
    convenience init(_ resource: FontResource, size: CGFloat) {
        self.init(name: resource.fontName, size: size)!
    }
}
```

이제 자동완성과 함께 폰트를 생성할 수 있습니다:
```swift
label.font = UIFont(.openSans_bold, size: 12)
```

### 다국어 문자열 로딩하기
https://github.com/nearfri/XCResource/assets/323940/8f7c0a85-f4fb-4c96-b6cb-0ed2d0f72698

`xcresource.json`에 아래와 같은 커맨드를 추가하고 `RunXCResource` 플러그인을 실행합니다:
```json
{
    "commands": [
        {
            "commandName": "xcstrings2swift",
            "catalogPath": "Sources/Resource/Resources/Localizable.xcstrings",
            "bundle": "at-url:Bundle.module.bundleURL",
            "swiftPath": "Sources/Resource/Keys/LocalizedStringResource+.swift"
        }
    ]
}
```

아래와 같은 코드가 생성됩니다:
```swift
public extension LocalizedStringResource {
    /// \"\\(param1)\" will be deleted.\
    /// This action cannot be undone.
    static func alert_delete_file(_ param1: String) -> Self {
        .init("alert_delete_file",
              defaultValue: """
                \"\(param1)\" will be deleted.
                This action cannot be undone.
                """,
              bundle: .atURL(Bundle.module.bundleURL))
    }

    /// Done
    static var common_done: Self {
        .init("common_done",
              defaultValue: "Done",
              bundle: .atURL(Bundle.module.bundleURL))
    }
}
```

**함수 시그니처와 다국어 키가 동일하다면 함수명이나 파라미터명은 변경하더라도 계속 유지됩니다.**

이제 자동완성과 함께 지역화된 문자열을 생성할 수 있습니다:
```swift
label.text = String(localized: .common_done)
```

`XCResourceSample.xcworkspace`에서 적용 예제를 볼 수 있습니다.

## 라이선스
XCResource는 MIT 라이선스에 따라 배포됩니다. 자세한 내용은 LICENSE를 참조하십시오.
