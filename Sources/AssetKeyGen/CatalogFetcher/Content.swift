import Foundation

enum ContentType: Hashable {
    case group
    case asset(AssetType)
    
    init(url: URL) {
        if let assetType = AssetType(pathExtension: url.pathExtension) {
            self = .asset(assetType)
        } else {
            self = .group
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

struct Content {
    var url: URL
    var type: ContentType
    var providesNamespace: Bool = false
    
    var name: String {
        if type == .group {
            return url.lastPathComponent
        } else {
            return url.deletingPathExtension().lastPathComponent
        }
    }
}

extension Content {
    init(url: URL) throws {
        self.url = url
        self.type = ContentType(url: url)
        
        let jsonURL = url.appendingPathComponent("Contents.json")
        if type.requiresAttributesLoading, let data = try? Data(contentsOf: jsonURL) {
            let record = try JSONDecoder().decode(ContentAttributesRecord.self, from: data)
            providesNamespace = record.properties?.providesNamespace ?? false
        }
    }
}
