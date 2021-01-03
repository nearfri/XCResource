import Foundation

extension Enumeration {
    struct Case: Equatable {
        var comment: String?
        var identifier: String
        var rawValue: RawValue
    }
}

struct Enumeration<RawValue: Equatable>: Equatable {
    var identifier: String
    var cases: [Case]
}
