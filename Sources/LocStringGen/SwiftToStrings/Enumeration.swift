import Foundation

struct Enumeration<RawValue: Equatable>: Equatable {
    var identifier: String
    var cases: [Case]
}

extension Enumeration {
    struct Case: Equatable {
        var comments: [Comment] = []
        var identifier: String
        var rawValue: RawValue
    }
}
