import Foundation

enum SwiftValue {}

extension SwiftValue {
    enum Accessibility: String, Comparable {
        case `private` = "source.lang.swift.accessibility.private"
        case `fileprivate` = "source.lang.swift.accessibility.fileprivate"
        case `internal` = "source.lang.swift.accessibility.internal"
        case `public` = "source.lang.swift.accessibility.public"
        case open = "source.lang.swift.accessibility.open"
        
        static func < (lhs: Accessibility, rhs: Accessibility) -> Bool {
            return lhs.accessibility < rhs.accessibility
        }
        
        private var accessibility: Int {
            switch self {
            case .private:      return 1
            case .fileprivate:  return 2
            case .internal:     return 3
            case .public:       return 4
            case .open:         return 5
            }
        }
    }
}

extension SwiftValue {
    struct Kind: Codable, Hashable, RawRepresentable, ExpressibleByStringLiteral {
        var rawValue: String
        
        init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        init(stringLiteral value: String) {
            self.rawValue = value
        }
        
        static let declExtension: Kind = "source.lang.swift.decl.extension"
        static let declVarInstance: Kind = "source.lang.swift.decl.var.instance"
        static let declVarParameter: Kind = "source.lang.swift.decl.var.parameter"
        static let declVarStatic: Kind = "source.lang.swift.decl.var.static"
        static let exprCall: Kind = "source.lang.swift.expr.call"
        static let exprArgument: Kind = "source.lang.swift.expr.argument"
    }
}
