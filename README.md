# XCResource
[![Swift](https://github.com/nearfri/XCResource/workflows/Swift/badge.svg)](https://github.com/nearfri/XCResource/actions?query=workflow%3ASwift)

XCResource는 xcassets 리소스 로딩과 다국어 지원을 도와주는 커맨드라인 툴입니다.

이를 이용해 이미지, 컬러, 다국어 문자열을 쉽게 생성할 수 있습니다:
```swift
let image = UIImage(key: .settings)
let color = UIColor(key: .coralPink)
let string = String(key: .done)
let text = String(form: .alert_attachTooLargeVideo(maxMinutes: maxMinutes))
```

## 제공기능
`xcresource`는 다음의 하위 커맨드를 가지고 있습니다:
- `xcassets2swift`: xcassets을 위한 Swift 코드를 생성합니다.
- `swift2strings`: Swift enum으로 strings 파일을 생성합니다.
- `key2form`: Swift enum으로 format string 코드를 생성합니다.
- `strings2csv`: strings 파일로 CSV 파일을 생성합니다.
- `csv2strings`: CSV 파일로 strings 파일을 생성합니다.

## 설치
[Mint](https://github.com/yonaskolb/Mint)로 XCResource를 설치합니다:
```sh
mint install nearfri/XCResource
```

## 사용 예제

### xcassets 이미지 로딩하기
`xcresource xcassets2swift`를 실행합니다:
```sh
xcrun --sdk macosx mint run xcresource xcassets2swift \
    --xcassets-path ../SampleApp/Assets.xcassets \
    --asset-type imageset \
    --swift-path ../SampleApp/ResourceKeys/ImageKey.swift \
    --swift-type-name ImageKey
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

### Swift enum으로 strings 파일 만들기
`enum` 타입의 `StringKey`를 만들어줍니다:
```swift
enum StringKey: String, CaseIterable {
    /// 취소
    case cancel
    
    /// 확인
    case confirm
}
```

`xcresource swift2strings`를 실행합니다:
```sh
xcrun --sdk macosx mint run xcresource swift2strings \
    --swift-path ../SampleApp/ResourceKeys/StringKey.swift \
    --resources-path ../SampleApp \
    --value-strategy ko:comment \
    --sort-by-key
```

아래와 같이 strings 파일이 업데이트 됩니다:
```
/* 취소 */
"cancel" = "취소";

/* 확인 */
"confirm" = "확인";
```

`String`에 생성자를 추가해줍니다:
```swift
extension String {
    static func localized(_ key: StringKey) -> String {
        return NSLocalizedString(key.rawValue, bundle: .module, comment: "")
    }
}
```

이제 자동완성과 함께 지역화된 문자열을 생성할 수 있습니다:
```swift
label.text = .localized(.cancel)
```

### Swift enum으로 format string 코드 만들기
`StringKey`의 `case`에 format string 형식의 주석을 추가합니다:
```swift
enum StringKey: String, CaseIterable {
    /// 동영상 첨부는 최대 %ld{maxMinutes}분까지 가능합니다.\n다른 파일을 선택해주세요.
    case alert_attachTooLargeVideo
}
```

`xcresource key2form`을 실행합니다:
```sh
xcrun --sdk macosx mint run xcresource key2form \
    --key-file-path ../SampleApp/ResourceKeys/StringKey.swift \
    --form-file-path ../SampleApp/ResourceKeys/StringForm.swift \
    --form-type-name StringForm \
    --issue-reporter xcode
```

아래와 같은 코드가 생성됩니다:
```swift
struct StringForm {
    var key: String
    var arguments: [CVarArg]
}

extension StringForm {
    /// 동영상 첨부는 최대 %ld{maxMinutes}분까지 가능합니다.\n다른 파일을 선택해주세요.
    static func alert_attachTooLargeVideo(maxMinutes: Int) -> StringForm {
        return StringForm(
            key: StringKey.alert_attachTooLargeVideo.rawValue,
            arguments: [maxMinutes])
    }
}
```

`String`에 생성자를 추가해줍니다:
```swift
extension String {
    static func formatted(_ form: StringForm) -> String {
        let format = NSLocalizedString(form.key, bundle: .module, comment: "")
        return String(format: format, locale: .current, arguments: form.arguments)
    }
}
```

이제 자동완성과 함께 지역화된 문자열을 생성할 수 있습니다:
```swift
label.text = .formatted(.alert_attachTooLargeVideo(maxMinutes: maxMinutes))
```

### strings 파일로 CSV 파일 만들기
`xcresource strings2csv`를 실행합니다:
```sh
mint run xcresource strings2csv \
    --resources-path ../SampleApp \
    --development-language ko \
    --csv-path ./translation.csv \
    --header-style long-ko \
    --write-bom
```

아래와 같은 csv 파일이 만들어집니다:
| Key | Comment | 한국어 (ko) | 영어 (en) |
| --- | ------- | --------- | -------- |
| cancel | 취소 | 취소 | |
| confirm | 확인 | 확인 | |

### CSV 파일로 strings 파일 만들기
`xcresource csv2strings`를 실행합니다:
```sh
mint run xcresource csv2strings \
    --csv-path ./translation.csv \
    --header-style long-ko \
    --resources-path ../SampleApp
```

아래와 같이 strings 파일이 만들어집니다:
```
/* 취소 */
"cancel" = "취소";

/* 확인 */
"confirm" = "확인";
```

`XCResourceSample.xcworkspace`에서 적용 예제를 볼 수 있습니다.

## 라이선스
XCResource는 MIT 라이선스에 따라 배포됩니다. 자세한 내용은 LICENSE를 참조하십시오.
