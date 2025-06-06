import Foundation
import XCResourceUtil

enum ContentType: Hashable, Sendable {
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

struct Content: Sendable {
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
    
    var namespace: String {
        return url.lastPathComponent.toTypeIdentifier()
    }
    
    var identifier: String {
        return url.deletingPathExtension().lastPathComponent.toIdentifier()
    }
}

extension Content {
    init(url: URL) throws {
        self.url = url
        self.type = ContentType(url: url)
        
        let jsonURL = url.appendingPathComponent("Contents.json")
        if type.requiresAttributesLoading, let data = try? Data(contentsOf: jsonURL) {
            let attributes = try JSONDecoder().decode(ContentAttributesDTO.self, from: data)
            providesNamespace = attributes.properties?.providesNamespace ?? false
        }
    }
}
