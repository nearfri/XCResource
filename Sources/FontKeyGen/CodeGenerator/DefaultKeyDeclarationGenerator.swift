import Foundation

class DefaultKeyDeclarationGenerator: KeyDeclarationGenerator {
    func generate(fonts: [Font], keyTypeName: String, accessLevel: String?) -> String {
        let accessLevel = accessLevel.map({ $0 + " " }) ?? ""
        
        var result = ""
        
        result += "\(accessLevel)extension \(keyTypeName) {\n"
        
        var currentFamilyName = ""
        var commentPrefix = ""
        for font in fonts {
            defer { commentPrefix = "    \n" }
            
            if font.familyName != currentFamilyName {
                result += commentPrefix
                result += "    // MARK: \(font.familyName)\n"
                result += "    \n"
                currentFamilyName = font.familyName
            } else {
                result += "    \n"
            }
            
            result += """
                    static let \(font.key): \(keyTypeName) = .init(
                        fontName: "\(font.fontName)",
                        familyName: "\(font.familyName)",
                        style: "\(font.style)",
                        path: "\(font.path)")
                
                """
        }
        
        result += "}"
        
        return result
    }
}
