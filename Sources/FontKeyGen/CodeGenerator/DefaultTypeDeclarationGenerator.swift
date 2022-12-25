import Foundation

class DefaultTypeDeclarationGenerator: TypeDeclarationGenerator {
    func generate(keyTypeName: String, accessLevel: String?) -> String {
        let accessLevel = accessLevel.map({ $0 + " " }) ?? ""
        
        return """
            \(accessLevel)struct \(keyTypeName): Hashable {
                \(accessLevel)var fontName: String
                \(accessLevel)var familyName: String
                \(accessLevel)var style: String
                \(accessLevel)var path: String
                
                \(accessLevel)init(fontName: String, familyName: String, style: String, path: String) {
                    self.fontName = fontName
                    self.familyName = familyName
                    self.style = style
                    self.path = path
                }
            }
            """
    }
}
