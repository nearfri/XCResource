import Foundation

public func assetURL(_ name: String = "") -> URL {
    let fullName = "Resources/Media.xcassets\(name.isEmpty ? "" : "/\(name)")"
    guard let url = Bundle.module.url(forResource: fullName, withExtension: nil) else {
        preconditionFailure("\(fullName) not found. Bundle: \(Bundle.module.bundlePath)")
    }
    return url
}

public func sourceCodeURL(_ filename: String) -> URL {
    let fullName = "Resources/SourceCode/\(filename)"
    guard let url = Bundle.module.url(forResource: fullName, withExtension: nil) else {
        preconditionFailure("\(fullName) not found. Bundle: \(Bundle.module.bundlePath)")
    }
    return url
}
