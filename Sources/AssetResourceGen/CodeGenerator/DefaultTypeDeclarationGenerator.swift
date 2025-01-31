import Foundation

class DefaultTypeDeclarationGenerator: TypeDeclarationGenerator {
    func generate(resourceTypeName: String, accessLevel: String?) -> String {
        let accessLevel = accessLevel.map({ $0 + " " }) ?? ""
        
        return """
            \(accessLevel)struct \(resourceTypeName): Hashable, Sendable {
                \(accessLevel)let name: String
                \(accessLevel)let bundle: Bundle
                
                \(accessLevel)init(name: String, bundle: Bundle) {
                    self.name = name
                    self.bundle = bundle
                }
            }
            """
    }
}
