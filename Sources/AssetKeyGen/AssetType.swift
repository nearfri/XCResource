import Foundation

// https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/AssetTypes.html

public enum AssetType: String, CaseIterable {
    case imageSet = "imageset"
    case colorSet = "colorset"
    case symbolSet = "symbolset"
    
    public var pathExtension: String {
        return rawValue
    }
    
    public var requiresAttributesLoading: Bool {
        return false
    }
}
