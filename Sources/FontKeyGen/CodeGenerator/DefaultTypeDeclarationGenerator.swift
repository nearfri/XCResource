import Foundation

class DefaultTypeDeclarationGenerator: TypeDeclarationGenerator {
    func generate(resourceTypeName: String, accessLevel: String?) -> String {
        let accessLevel = accessLevel.map({ $0 + " " }) ?? ""
        
        return """
            \(accessLevel)struct \(resourceTypeName): Hashable, Sendable {
                \(accessLevel)let fontName: String
                \(accessLevel)let familyName: String
                \(accessLevel)let style: String
                \(accessLevel)let relativePath: String
                \(accessLevel)let bundle: Bundle
                
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
                    return URL(filePath: relativePath, relativeTo: bundle.resourceURL)\
            .standardizedFileURL
                }
                
                \(accessLevel)var path: String {
                    return url.path(percentEncoded: false)
                }
            }
            """
    }
}
