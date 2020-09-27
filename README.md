# ResourceKey

## generate-asset-keys
Xcode Asset Catalog (.xcassets 폴더) 에서 리소스 이름을 추출해서 키 파일을 생성해주는 툴입니다.

### Usage
아래의 커맨드는 `<Assets.xcassets>`가 포함한 모든 이미지들의 이름을 `ImageKey.swift`에 저장합니다.

```sh
swift run --package-path <path/to/ResourceKey> generate-asset-keys \
    --input-xcassets <path/to/Assets.xcassets> \
    --asset-type image \
    --key-type-name <ImageKey> \
    --key-decl-file <path/to/ImageKey.swift>
```

```swift
// ImageKey.swift

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
    
    // MARK: Common/BGMNavigationBar
    static let icoFold: ImageKey = "icoFold"
    static let icoFoldPressed: ImageKey = "icoFoldPressed"
    static let icoMusic: ImageKey = "icoMusic"
    static let icoMusicPressed: ImageKey = "icoMusicPressed"
    ...
```

`--key-list-file <key-list-file>` 옵션을 추가하면 키 리스트를 `<key-list-file>`에 저장합니다.

```sh
swift run --package-path <path/to/ResourceKey> generate-asset-keys \
    --input-xcassets <path/to/Assets.xcassets> \
    --asset-type image \
    --key-type-name <ImageKey> \
    --module-name <MyAppName> \
    --key-decl-file <path/to/ImageKey.swift> \
    --key-list-file <path/to/AllImageKeys.swift>
```

```swift
// AllImageKeys.swift

@testable import ResourceKeyApp

extension ImageKey {
    static let allGeneratedKeys: Set<ImageKey> = [
        // MARK: Assets.xcassets
        .appIcon,
        .icoFold,
        .icoFoldPressed,
        .icoMusic,
        .icoMusicPressed,
        ...
```

위에서 생성한 파일을 프로젝트에 추가한 후 `UIImage`와 `Image`에 `extension`을 추가합니다.

```swift
import UIKit
import SwiftUI

extension UIImage {
    convenience init(key: ImageKey) {
        self.init(named: key.rawValue, in: .module, compatibleWith: nil)!
    }
}

extension Image {
    init(key: ImageKey) {
        self.init(key.rawValue, bundle: .module)
    }
    
    init(key: ImageKey, label: Text) {
        self.init(key.rawValue, bundle: .module, label: label)
    }
}
```

이제 자동완성과 함께 오타 걱정없이 이미지를 로딩할 수 있습니다.

```swift
imageView.image = UIImage(key: .icoMusic)
```

`ResourceKeySample.xcworkspace`에서 적용 예제를 볼 수 있습니다.
