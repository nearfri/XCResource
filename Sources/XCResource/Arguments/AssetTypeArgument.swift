import Foundation
import ArgumentParser
import AssetKeyGen

enum AssetTypeArgument: RawRepresentable {
    case all
    case one(AssetType)
    
    var rawValue: String {
        switch self {
        case .all:
            return "all"
        case .one(let assetType):
            return assetType.pathExtension
        }
    }
    
    init?(rawValue: String) {
        if rawValue == AssetTypeArgument.all.rawValue {
            self = .all
        } else if let assetType = AssetType(pathExtension: rawValue) {
            self = .one(assetType)
        } else {
            return nil
        }
    }
}

extension AssetTypeArgument: ExpressibleByArgument {
    var defaultValueDescription: String {
        return rawValue
    }
    
    static var allValueStrings: [String] {
        let allValues: [AssetTypeArgument] = [.all] + AssetType.allCases.map({ .one($0) })
        return allValues.map(\.rawValue)
    }
    
    static var someValueStrings: [String] {
        let someAssetTypes: [AssetType] = [.imageSet, .colorSet, .symbolSet, .dataSet]
        let someValues: [AssetTypeArgument] = [.all] + someAssetTypes.map({ .one($0) })
        return someValues.map(\.rawValue) + ["..."]
    }
}

extension Array where Element == AssetTypeArgument {
    var assetTypes: Set<AssetType> {
        return reduce(into: []) { result, argument in
            switch argument {
            case .all:
                result.formUnion(AssetType.allCases)
            case .one(let assetType):
                result.insert(assetType)
            }
        }
    }
}
