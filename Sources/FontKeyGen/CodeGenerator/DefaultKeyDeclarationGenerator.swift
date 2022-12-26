import Foundation

class DefaultKeyDeclarationGenerator: KeyDeclarationGenerator {
    func generateAllKeysDeclaration(for request: KeyDeclarationRequest) -> String {
        let accessLevel = request.accessLevel.map({ $0 + " " }) ?? ""
        
        var result = ""
        
        result += """
            \(accessLevel)extension \(request.keyTypeName) {
                static let allKeys: [\(request.keyTypeName)] = [
            
            """
        
        var currentFamilyName = ""
        var commentPrefix = ""
        for font in request.fonts {
            defer { commentPrefix = "        \n" }
            
            if font.familyName != currentFamilyName {
                result += commentPrefix
                result += "        // \(font.familyName)\n"
                currentFamilyName = font.familyName
            }
            
            result += """
                        .\(font.key),
                
                """
        }
        
        result += """
                ]
            }
            """
        
        return result
    }
    
    func generateKeyDeclarations(for request: KeyDeclarationRequest) -> String {
        let accessLevel = request.accessLevel.map({ $0 + " " }) ?? ""
        
        var result = ""
        
        result += "\(accessLevel)extension \(request.keyTypeName) {\n"
        
        var currentFamilyName = ""
        var commentPrefix = ""
        for font in request.fonts {
            defer { commentPrefix = "    \n" }
            
            if font.familyName != currentFamilyName {
                result += commentPrefix
                result += "    // MARK: \(font.familyName)\n"
                currentFamilyName = font.familyName
            }
            
            result += """
                    
                    static let \(font.key): \(request.keyTypeName) = .init(
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
