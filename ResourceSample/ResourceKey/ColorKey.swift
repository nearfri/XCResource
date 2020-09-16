import Foundation

struct ColorKey: ExpressibleByStringLiteral {
    var rawValue: String
    
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    init(stringLiteral value: String) {
        self.rawValue = value
    }
}

extension ColorKey {
    static let battleshipGrey8: ColorKey = "battleshipGrey8"
}
