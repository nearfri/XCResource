import Foundation

// https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/AssetTypes.html

public enum AssetType: CaseIterable {
    case imageSet, colorSet, symbolSet
    
    public var pathExtension: String {
        switch self {
        case .imageSet:     return "imageset"
        case .colorSet:     return "colorset"
        case .symbolSet:    return "symbolset"
        }
    }
    
    public var requiresAttributesLoading: Bool {
        return false
    }
}
