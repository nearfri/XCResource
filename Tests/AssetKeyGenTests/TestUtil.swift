import Foundation
import SampleData

func assetURL(_ name: String = "") -> URL {
    let fullName = "Resources/Media.xcassets\(name.isEmpty ? "" : "/\(name)")"
    guard let url = Bundle.sample.url(forResource: fullName, withExtension: nil) else {
        preconditionFailure("Media.xcassets not found. Bundle: \(Bundle.sample.bundlePath)")
    }
    return url
}

