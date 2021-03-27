import Foundation

class DefaultTypeDeclarationGenerator: TypeDeclarationGenerator {
    func generate(keyTypeName: String) -> String {
        return """
            struct \(keyTypeName): ExpressibleByStringLiteral, Hashable {
                var rawValue: String
                
                init(_ rawValue: String) {
                    self.rawValue = rawValue
                }
                
                init(stringLiteral value: String) {
                    self.rawValue = value
                }
            }
            """
    }
}
