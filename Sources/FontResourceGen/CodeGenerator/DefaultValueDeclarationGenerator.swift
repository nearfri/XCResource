import Foundation

class DefaultValueDeclarationGenerator: ValueDeclarationGenerator {
    func generateValueListDeclaration(for request: ValueDeclarationRequest) -> String? {
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
            
            let fontID = font.id(
                transformingToLatin: request.transformsToLatin,
                strippingCombiningMarks: request.stripsCombiningMarks)
            
            result += """
                        .\(fontID),
                
                """
        }
        
        result += """
                ]
            }
            """
        
        return result
    }
    
    func generateValueDeclarations(for request: ValueDeclarationRequest) -> String {
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
            
            let fontID = font.id(
                transformingToLatin: request.transformsToLatin,
                strippingCombiningMarks: request.stripsCombiningMarks)
            
            result += """
                    
                    static let \(fontID): \(request.resourceTypeName) = .init(
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
    
    private func relativePath(of font: Font, for request: ValueDeclarationRequest) -> String {
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
