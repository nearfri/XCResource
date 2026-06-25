import Foundation

class DefaultTypeDeclarationGenerator: TypeDeclarationGenerator {
    func generate(resourceTypeName: String, accessLevel: String?) -> String {
        let accessLevel = accessLevel.map({ $0 + " " }) ?? ""
        
        // let url = URL(filePath: "Library", relativeTo: URL(fileURLWithPath: "/System"))
        // print(url.path(percentEncoded: false)) // iOS18: Library, iOS26: /System/Library
        // print(url.standardizedFileURL.path(percentEncoded: false)) // All: /System/Library
        return """
            \(accessLevel)struct \(resourceTypeName): Equatable, Sendable {
                \(accessLevel)let fontName: String
                \(accessLevel)let familyName: String
                \(accessLevel)let style: String
                \(accessLevel)let symbolicTraits: CTFontSymbolicTraits
                \(accessLevel)let relativePath: String
                \(accessLevel)let bundle: Bundle
                \(accessLevel)let url: URL
                
                \(accessLevel)init(
                    fontName: String,
                    familyName: String,
                    style: String,
                    symbolicTraits: CTFontSymbolicTraits,
                    relativePath: String,
                    bundle: Bundle
                ) {
                    self.fontName = fontName
                    self.familyName = familyName
                    self.style = style
                    self.symbolicTraits = symbolicTraits
                    self.relativePath = relativePath
                    self.bundle = bundle
                    self.url = URL(filePath: relativePath, relativeTo: bundle.resourceURL)\
            .standardizedFileURL
                }
                
                \(accessLevel)var path: String {
                    return url.path(percentEncoded: false)
                }
            }
            """
    }
}
