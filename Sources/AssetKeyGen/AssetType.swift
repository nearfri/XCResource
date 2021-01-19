import Foundation

// https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_ref-Asset_Catalog_Format/AssetTypes.html

public enum AssetType: String, CaseIterable {
    case appIconSet, arImageSet, arResourceGroup, brandAssets, cubeTextureSet,
         dataSet, gcDashboardImage, gcLeaderboard, gcLeaderboardSet, iconSet,
         imageSet, imageStack, imageStackLayer, launchImage, mipmapSet,
         colorSet, spriteAtlas, sticker, stickerPack, stickerSequence,
         textureSet, complicationSet, symbolSet
    
    public init?(pathExtension: String) {
        guard let type = AssetType.typesByPathExtension[pathExtension] else { return nil }
        self = type
    }
    
    public var pathExtension: String {
        return rawValue.lowercased()
    }
    
    private static let typesByPathExtension: [String: AssetType] = {
        let allTypes = AssetType.allCases
        let allExtensions = allTypes.map(\.pathExtension)
        return Dictionary(uniqueKeysWithValues: zip(allExtensions, allTypes))
    }()
    
    public var requiresAttributesLoading: Bool {
        return self == .spriteAtlas
    }
}
