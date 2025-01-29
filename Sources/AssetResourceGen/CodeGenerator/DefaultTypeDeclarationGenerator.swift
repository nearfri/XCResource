import Foundation

class DefaultTypeDeclarationGenerator: TypeDeclarationGenerator {
    func generate(resourceTypeName: String, accessLevel: String?) -> String {
        let accessLevel = accessLevel.map({ $0 + " " }) ?? ""
        let typeName = resourceTypeName
        
        return """
            \(accessLevel)struct \(typeName): ExpressibleByStringLiteral, Hashable, Sendable {
                \(accessLevel)let rawValue: String
                
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
