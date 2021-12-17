import Foundation

class DefaultTypeDeclarationGenerator: TypeDeclarationGenerator {
    func generate(keyTypeName: String, accessLevel: String?) -> String {
        let accessLevel = accessLevel.map({ $0 + " " }) ?? ""
        
        return """
            \(accessLevel)struct \(keyTypeName): ExpressibleByStringLiteral, Hashable {
                \(accessLevel)var rawValue: String
                
                \(accessLevel)init(_ rawValue: String) {
                    self.rawValue = rawValue
                }
                
                \(accessLevel)init(stringLiteral value: String) {
                    self.rawValue = value
                }
            }
            """
    }
}
