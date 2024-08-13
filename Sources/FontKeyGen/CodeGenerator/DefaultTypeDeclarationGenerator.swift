import Foundation

class DefaultTypeDeclarationGenerator: TypeDeclarationGenerator {
    func generate(keyTypeName: String, accessLevel: String?) -> String {
        let accessLevel = accessLevel.map({ $0 + " " }) ?? ""
        
        return """
            \(accessLevel)struct \(keyTypeName): Hashable {
                \(accessLevel)var fontName: String
                \(accessLevel)var familyName: String
                \(accessLevel)var style: String
                \(accessLevel)var relativePath: String
                \(accessLevel)var bundle: Bundle
                
                \(accessLevel)init(
                    fontName: String,
                    familyName: String,
                    style: String,
                    relativePath: String,
                    bundle: Bundle
                ) {
                    self.fontName = fontName
                    self.familyName = familyName
                    self.style = style
                    self.relativePath = relativePath
                    self.bundle = bundle
                }
                
                \(accessLevel)var url: URL {
                    return URL(filePath: relativePath, relativeTo: bundle.resourceURL)
                }
            }
            """
    }
}
