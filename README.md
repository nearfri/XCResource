# XCResource
XCResource는 xcassets 리소스 로딩과 다국어 지원을 도와주는 커맨드라인 툴입니다.

`xcresource`는 다음의 하위 커맨드를 가지고 있습니다:
- `xcassets2swift`: xcassets을 위한 Swift 코드를 생성합니다.
- `swift2strings`: Swift 코드를 strings 파일로 변환합니다.
- `strings2csv`: strings 파일을 CSV 파일로 변환합니다.
- `csv2strings`: CSV 파일을 strings 파일로 변환합니다.

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
    --asset-type image \
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
    static let appIcon: ImageKey = "AppIcon"
    
    // MARK: Common/NavigationBar
    static let icoMusic: ImageKey = "icoMusic"
    static let icoMusicPressed: ImageKey = "icoMusicPressed"
    
    // MARK: Common
    static let btnSelect: ImageKey = "btnSelect"
    ...
```

`UIImage`에 생성자를 추가해줍니다:
```swift
extension UIImage {
    convenience init(key: ImageKey) {
        self.init(named: key.rawValue, in: .module, compatibleWith: nil)!
    }
}
```

이제 자동완성과 함께 이미지를 생성할 수 있습니다:
```swift
imageView.image = UIImage(key: .icoMusic)
```

### Swift 코드를 strings 파일로 변환하기
`enum` 타입의 `StringKey`를 만들어줍니다:
```swift
enum StringKey: String, CaseIterable {
    /// 취소
    case cancel
    
    /// 확인
    case confirm
}
```

`String`에 생성자를 추가해줍니다:
```swift
extension String {
    init(key: StringKey) {
        self = NSLocalizedString(key.rawValue, bundle: .module, comment: "")
    }
}
```

`xcresource swift2strings`를 실행합니다:
```sh
xcrun --sdk macosx mint run xcresource xcresource swift2strings \
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

이제 자동완성과 함께 지역화된 문자열을 생성할 수 있습니다:
```swift
label.text = String(key: .cancel)
```

### strings 파일을 CSV 파일로 변환하기
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

### CSV 파일을 strings 파일로 변환하기
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
