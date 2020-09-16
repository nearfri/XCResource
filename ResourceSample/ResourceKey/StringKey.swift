import Foundation

struct StringKey {
    var rawValue: String
    
    init(_ rawValue: String, comment: String) {
        self.rawValue = rawValue
    }
}

extension StringKey {
    static let error_description_invalidVersion = StringKey("error_description_invalidVersion",
                                                            comment: "")
}
