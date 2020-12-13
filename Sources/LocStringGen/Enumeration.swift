import Foundation

extension Enumeration {
    struct Case: Hashable {
        var comment: String?
        var identifier: String
        var rawValue: RawValue
    }
}

struct Enumeration<RawValue: Hashable>: Hashable {
    var identifier: String
    var cases: [Case]
}
