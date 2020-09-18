import Foundation

struct ContentRecord: Decodable {
    enum ContentType: CaseIterable {
        case imageSet, colorSet, symbolSet
        
        func toContainerType() -> ContainerType {
            switch self {
            case .imageSet:     return .imageSet
            case .colorSet:     return .colorSet
            case .symbolSet:    return .symbolSet
            }
        }
        
        fileprivate var codingKey: CodingKeys {
            switch self {
            case .imageSet:     return .images
            case .colorSet:     return .colors
            case .symbolSet:    return .symbols
            }
        }
    }
    
    struct Properties: Decodable {
        private enum CodingKeys: String, CodingKey {
            case providesNamespace = "provides-namespace"
        }
        
        var providesNamespace: Bool
    }
    
    fileprivate enum CodingKeys: String, CodingKey {
        case info, properties, images, colors, symbols
    }
    
    var type: ContentType?
    var properties: Properties?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let allKeys = container.allKeys.map({ $0.stringValue })
        
        self.type = ContentType.allCases.first { type in
            allKeys.contains(type.codingKey.stringValue)
        }
        
        self.properties = try container.decodeIfPresent(Properties.self, forKey: .properties)
    }
}
