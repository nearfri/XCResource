import Foundation
import SourceKittenFramework

// SourceKittenFramework.Structure에서 키 리스트를 추출하는데 필요한 값들만 담는다
struct SwiftStructure: Codable {
    var accessibility: String?
    var kind: String?
    var name: String?
    var typeName: String?
    var offset: Int?
    var substructures: [SwiftStructure]?
    
    enum CodingKeys: String, CodingKey {
        case accessibility = "key.accessibility"
        case kind = "key.kind"
        case name = "key.name"
        case offset = "key.offset"
        case substructures = "key.substructure"
        case typeName = "key.typename"
    }
}

extension SwiftStructure {
    init(dictionary: [String: SourceKitRepresentable]) {
        func value<T>(for key: CodingKeys, type: T.Type = T.self) -> T? {
            return dictionary[key.rawValue] as? T
        }
        
        self.accessibility = value(for: .accessibility)
        self.kind = value(for: .kind)
        self.name = value(for: .name)
        self.typeName = value(for: .typeName)
        self.offset = value(for: .offset, type: Int64.self).map(Int.init)
        
        self.substructures = dictionary[CodingKeys.substructures.rawValue]
            .flatMap({ $0 as? [[String: SourceKitRepresentable]] })
            .map({ $0.map({ SwiftStructure(dictionary: $0) }) })
    }
}
