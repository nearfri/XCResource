import Foundation

public func resourcesURL() -> URL {
    let fullName = "Resources"
    guard let url = Bundle.module.url(forResource: fullName, withExtension: nil) else {
        preconditionFailure("\(fullName) not found. Bundle: \(Bundle.module.bundlePath)")
    }
    return url
}

public func fontDirectoryURL() -> URL {
    return resourcesURL().appendingPathComponent("Fonts")
}

public func assetURL(_ name: String = "") -> URL {
    let fullName = "Resources/Media.xcassets\(name.isEmpty ? "" : "/\(name)")"
    guard let url = Bundle.module.url(forResource: fullName, withExtension: nil) else {
        preconditionFailure("\(fullName) not found. Bundle: \(Bundle.module.bundlePath)")
    }
    return url
}
