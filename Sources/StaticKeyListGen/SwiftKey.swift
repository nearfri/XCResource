import Foundation

struct SwiftKey: ExpressibleByStringLiteral, Hashable {
    var rawValue: String
    
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    init(stringLiteral value: String) {
        self.rawValue = value
    }
}

extension SwiftKey {
    static let accessibility: SwiftKey = "key.accessibility"
    static let bodyLength: SwiftKey = "key.bodylength"
    static let bodyOffset: SwiftKey = "key.bodyoffset"
    static let column: SwiftKey = "key.column"
    static let description: SwiftKey = "key.description"
    static let diagnostics: SwiftKey = "key.diagnostics"
    static let diagnosticStage: SwiftKey = "key.diagnostic_stage"
    static let docLength: SwiftKey = "key.doclength"
    static let docOffset: SwiftKey = "key.docoffset"
    static let elements: SwiftKey = "key.elements"
    static let filePath: SwiftKey = "key.filepath"
    static let fixIts: SwiftKey = "key.fixits"
    static let inheritedTypes: SwiftKey = "key.inheritedtypes"
    static let kind: SwiftKey = "key.kind"
    static let length: SwiftKey = "key.length"
    static let line: SwiftKey = "key.line"
    static let name: SwiftKey = "key.name"
    static let nameLength: SwiftKey = "key.namelength"
    static let nameOffset: SwiftKey = "key.nameoffset"
    static let offset: SwiftKey = "key.offset"
    static let setterAccessibility: SwiftKey = "key.setter_accessibility"
    static let severity: SwiftKey = "key.severity"
    static let sourceText: SwiftKey = "key.sourcetext"
    static let substructure: SwiftKey = "key.substructure"
    static let typeName: SwiftKey = "key.typename"
}
