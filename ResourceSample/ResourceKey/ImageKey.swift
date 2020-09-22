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

// MARK: - Media.xcassets

extension ImageKey {
    
    // MARK: Common/Button
    static let btnSelect: ImageKey = "btnSelect"
    
}
