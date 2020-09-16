import Foundation

struct ImageKey: ExpressibleByStringLiteral {
    var rawValue: String
    
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    init(stringLiteral value: String) {
        self.rawValue = value
    }
}

extension ImageKey {
    // MARK: - ImageKey > Button
    static let btnSelect: ImageKey = "btnSelect"
}
