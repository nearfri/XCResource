import Foundation

class DefaultKeyDeclarationGenerator: KeyDeclarationGenerator {
    func generateKeyListDeclaration(for request: KeyDeclarationRequest) -> String? {
        guard let resourceListName = request.resourceListName else { return nil }
        
        let accessLevel = request.accessLevel.map({ $0 + " " }) ?? ""
        
        var result = ""
        
        result += """
            \(accessLevel)extension \(request.resourceTypeName) {
                static let \(resourceListName): [\(request.resourceTypeName)] = [
            
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
            
            let fontKey = font.key(asLatin: request.generatesLatinKey,
                                   strippingCombiningMarks: request.stripsCombiningMarksFromKey)
            
            result += """
                        .\(fontKey),
                
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
        
        result += "\(accessLevel)extension \(request.resourceTypeName) {\n"
        
        var currentFamilyName = ""
        var commentPrefix = ""
        for font in request.fonts {
            defer { commentPrefix = "    \n" }
            
            if font.familyName != currentFamilyName {
                result += commentPrefix
                result += "    // MARK: \(font.familyName)\n"
                currentFamilyName = font.familyName
            }
            
            let fontKey = font.key(asLatin: request.generatesLatinKey,
                                   strippingCombiningMarks: request.stripsCombiningMarksFromKey)
            
            result += """
                    
                    static let \(fontKey): \(request.resourceTypeName) = .init(
                        fontName: "\(font.fontName)",
                        familyName: "\(font.familyName)",
                        style: "\(font.style)",
                        relativePath: "\(relativePath(of: font, for: request))",
                        bundle: \(request.bundle))
                
                """
        }
        
        result += "}"
        
        return result
    }
    
    private func relativePath(of font: Font, for request: KeyDeclarationRequest) -> String {
        var result = font.relativePath
        
        if !request.preservesRelativePath {
            result = result.lastPathComponent
        }
        
        if let relativePathPrefix = request.relativePathPrefix {
            result = relativePathPrefix.appendingPathComponent(result)
        }
        
        return result
    }
}
