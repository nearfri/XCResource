# XCResource
[![Swift](https://github.com/nearfri/XCResource/workflows/Swift/badge.svg)](https://github.com/nearfri/XCResource/actions?query=workflow%3ASwift)
[![codecov](https://codecov.io/gh/nearfri/XCResource/branch/main/graph/badge.svg?token=DWKDFE0O2A)](https://codecov.io/gh/nearfri/XCResource)

XCResource는 xcassets 리소스 로딩과 다국어 지원을 도와주는 커맨드라인 툴입니다.

이를 이용해 이미지, 컬러, 다국어 문자열을 쉽게 생성할 수 있습니다:
```swift
let image = UIImage.named(.settings)
let color = UIColor.named(.coralPink)
let string = String.localized(.done)
let text = String.formatted(.alert_deleteFile(fileName: fileName))
```

## 제공기능
`xcresource`는 다음의 하위 커맨드를 가지고 있습니다:
- `xcassets2swift`: xcassets을 위한 Swift 코드를 생성합니다.
- `strings2swift`: strings 파일로 Swift enum을 생성합니다.
- `swift2strings`: Swift enum으로 strings 파일을 생성합니다.
- `key2form`: Swift enum으로 format string 코드를 생성합니다.
- `strings2csv`: strings 파일로 CSV 파일을 생성합니다.
- `csv2strings`: CSV 파일로 strings 파일을 생성합니다.
- `init`: Manifest 파일을 생성합니다. 
- `run (default)`: Manifest 파일에 나열된 하위 커맨드들을 실행합니다.

## 설치
[Mint](https://github.com/yonaskolb/Mint)
```sh
mint install nearfri/XCResource
```

Make
```sh
git clone https://github.com/nearfri/XCResource.git
cd XCResource
make build install
```

## 사용 예제

### xcassets 이미지 로딩하기
https://user-images.githubusercontent.com/323940/202911680-3bb7bed7-ccaf-40c2-b136-439ff05b983b.mov

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

### strings 파일로 Swift enum 만들기
https://user-images.githubusercontent.com/323940/202911792-bc48ef57-0ff3-404b-84b4-94931350e847.mov

`enum` 타입의 빈 `StringKey`를 만들어줍니다:
```swift
enum StringKey: String, CaseIterable {

}
```

`String`에 생성자를 추가합니다:
```swift
extension String {
    static func localized(_ key: StringKey) -> String {
        return NSLocalizedString(key.rawValue, bundle: .module, comment: "")
    }
}
```

strings 파일을 준비합니다:
```
"cancel" = "취소";
"confirm" = "확인";
```

`xcresource strings2swift`를 실행합니다:
```sh
xcrun --sdk macosx mint run xcresource strings2swift \
    --resources-path ../SampleApp \
    --language ko \
    --swift-path ../SampleApp/ResourceKeys/StringKey.swift \
```

아래와 같이 `StringKey`가 업데이트 됩니다:
```swift
enum StringKey: String, CaseIterable {
    /// 취소
    case cancel
    
    /// 확인
    case confirm
}
```

이제 자동완성과 함께 지역화된 문자열을 생성할 수 있습니다:
```swift
label.text = .localized(.cancel)
```

### Swift enum으로 strings 파일 만들기
https://user-images.githubusercontent.com/323940/202911866-cbd49782-05c8-4908-8e34-5187ad867331.mov

`swift2strings`는 `strings2swift`와는 반대로 `enum`을 strings로 변환해줍니다.
```sh
xcrun --sdk macosx mint run xcresource swift2strings \
    --swift-path ../SampleApp/ResourceKeys/StringKey.swift \
    --resources-path ../SampleApp \
    --language-config ko:comment
```

아래와 같이 strings 파일이 업데이트 됩니다:
```
/* 취소 */
"cancel" = "취소";

/* 확인 */
"confirm" = "확인";
```

### Swift enum으로 format string 코드 만들기
https://user-images.githubusercontent.com/323940/202911913-b9603b3b-cac7-40c2-8573-75e7617edd9c.mov

`StringKey`의 `case`에 format string 형식의 주석을 추가합니다:
```swift
enum StringKey: String, CaseIterable {
    /// "%{fileName}" 파일은 삭제됩니다.\n이 동작은 취소할 수 없습니다.
    case alert_deleteFile
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
    /// "%{fileName}" 파일은 삭제됩니다.\n이 동작은 취소할 수 없습니다.
    static func alert_deleteFile(fileName: String) -> StringForm {
        return StringForm(key: StringKey.alert_deleteFile.rawValue, arguments: [fileName])
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
label.text = .formatted(.alert_deleteFile(fileName: fileName))
```

### strings 파일로 CSV 파일 만들기
https://user-images.githubusercontent.com/323940/202911933-e1041967-9fd1-4eb5-9c73-999cdbbb6a13.mov

`xcresource strings2csv`를 실행합니다:
```sh
mint run xcresource strings2csv \
    --resources-path ../SampleApp \
    --development-language ko \
    --csv-path ./localizations.csv \
    --header-style long-ko \
    --write-bom
```

아래와 같은 csv 파일이 만들어집니다:
| Key | Comment | 한국어 (ko) | 영어 (en) |
| --- | ------- | --------- | -------- |
| cancel | 취소 | 취소 | |
| confirm | 확인 | 확인 | |

### CSV 파일로 strings 파일 만들기
https://user-images.githubusercontent.com/323940/202911964-00ebcb96-90d8-430d-8385-e0cecbe8b181.mov

`xcresource csv2strings`를 실행합니다:
```sh
mint run xcresource csv2strings \
    --csv-path ./localizations.csv \
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
