import Foundation
import XCResourceUtil

public struct LocalizationItem: Equatable, Identifiable, SettableByKeyPath {
    public let id: String
    public var key: String
    public var value: String
    public var comment: String?
    
    public init(id: String? = nil, key: String, value: String, comment: String? = nil) {
        self.id = id ?? key
        self.key = key
        self.value = value
        self.comment = comment
    }
}
