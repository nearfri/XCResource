import Foundation

struct ContentAttributesDTO: Decodable, Sendable {
    struct Properties: Decodable {
        private enum CodingKeys: String, CodingKey {
            case providesNamespace = "provides-namespace"
        }
        
        var providesNamespace: Bool?
    }
    
    fileprivate enum CodingKeys: String, CodingKey {
        case properties
    }
    
    var properties: Properties?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.properties = try container.decodeIfPresent(Properties.self, forKey: .properties)
    }
}
