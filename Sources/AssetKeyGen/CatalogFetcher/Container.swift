import Foundation

enum ContainerType: Hashable {
    case group
    case asset(AssetType)
    
    init(url: URL) {
        let pathExtension = url.pathExtension
        if pathExtension.isEmpty {
            self = .group
        } else {
            let allAssetTypes = AssetType.allCases
            if let assetType = allAssetTypes.first(where: { $0.pathExtension == pathExtension }) {
                self = .asset(assetType)
            } else {
                self = .group
            }
        }
    }
    
    var requiresAttributesLoading: Bool {
        switch self {
        case .group:
            return true
        case .asset(let assetType):
            return assetType.requiresAttributesLoading
        }
    }
}

struct Container {
    var url: URL
    var type: ContainerType
    var providesNamespace: Bool = false
    
    var name: String {
        if type == .group {
            return url.lastPathComponent
        } else {
            return url.deletingPathExtension().lastPathComponent
        }
    }
}

extension Container {
    init(contentsOf url: URL) throws {
        self.url = url
        self.type = ContainerType(url: url)
        
        let jsonURL = url.appendingPathComponent("Contents.json")
        if type.requiresAttributesLoading, let data = try? Data(contentsOf: jsonURL) {
            let record = try JSONDecoder().decode(ContentRecord.self, from: data)
            providesNamespace = record.properties?.providesNamespace ?? false
        }
    }
}
