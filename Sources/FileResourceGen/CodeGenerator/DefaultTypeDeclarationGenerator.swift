import Foundation

class DefaultTypeDeclarationGenerator: TypeDeclarationGenerator {
    func generate(resourceTypeName: String, accessLevel: String?) -> String {
        let accessLevel = accessLevel.map({ $0 + " " }) ?? ""
        
        // let url = URL(filePath: "Library", relativeTo: URL(fileURLWithPath: "/System"))
        // print(url.path(percentEncoded: false)) // iOS18: Library, iOS26: /System/Library
        // print(url.standardizedFileURL.path(percentEncoded: false)) // All: /System/Library
        return """
            \(accessLevel)struct \(resourceTypeName): Hashable, Sendable {
                \(accessLevel)let relativePath: String
                \(accessLevel)let bundle: Bundle
                \(accessLevel)let url: URL
                
                \(accessLevel)init(relativePath: String, bundle: Bundle) {
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
