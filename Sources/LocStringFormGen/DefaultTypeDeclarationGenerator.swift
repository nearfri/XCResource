import Foundation

class DefaultTypeDeclarationGenerator: TypeDeclarationGenerator {
    func generate(formTypeName: String, accessLevel: String?) -> String {
        let accessLevel = accessLevel.map({ $0 + " " }) ?? ""
        
        return """
            \(accessLevel)struct \(formTypeName) {
                \(accessLevel)var key: String
                \(accessLevel)var arguments: [CVarArg]
                
                \(accessLevel)init(key: String, arguments: [CVarArg]) {
                    self.key = key
                    self.arguments = arguments
                }
            }
            """
    }
}
