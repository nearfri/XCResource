import Foundation

protocol FontImporter: AnyObject {
    func `import`(at url: URL) throws -> [Font]
}

protocol TypeDeclarationGenerator: AnyObject {
    func generate(keyTypeName: String, accessLevel: String?) -> String
}

protocol KeyDeclarationGenerator: AnyObject {
    func generate(fonts: [Font], keyTypeName: String, accessLevel: String?) -> String
}

extension FontKeyGenerator {
    public struct Request {
        public var fontsURL: URL
        public var keyTypeName: String
        public var accessLevel: String?
        
        public init(fontsURL: URL,
                    keyTypeName: String,
                    accessLevel: String? = nil
        ) {
            self.fontsURL = fontsURL
            self.keyTypeName = keyTypeName
            self.accessLevel = accessLevel
        }
    }
    
    public struct Result {
        public var typeDeclaration: String
        public var keyDeclarations: String
        
        public init(typeDeclaration: String, keyDeclarations: String) {
            self.typeDeclaration = typeDeclaration
            self.keyDeclarations = keyDeclarations
        }
    }
}

public class FontKeyGenerator {
    private let fontImporter: FontImporter
    private let typeDeclarationGenerator: TypeDeclarationGenerator
    private let keyDeclarationGenerator: KeyDeclarationGenerator
    
    init(fontImporter: FontImporter,
         typeDeclarationGenerator: TypeDeclarationGenerator,
         keyDeclarationGenerator: KeyDeclarationGenerator
    ) {
        self.fontImporter = fontImporter
        self.typeDeclarationGenerator = typeDeclarationGenerator
        self.keyDeclarationGenerator = keyDeclarationGenerator
    }
    
    public convenience init() {
        self.init(fontImporter: DefaultFontImporter(),
                  typeDeclarationGenerator: DefaultTypeDeclarationGenerator(),
                  keyDeclarationGenerator: DefaultKeyDeclarationGenerator())
    }
    
    public func generate(for request: Request) throws -> Result {
        let typeDeclaration = generateTypeDeclaration(for: request)
        
        let keyDeclarations = try generateKeyDeclarations(for: request)
        
        return Result(typeDeclaration: typeDeclaration, keyDeclarations: keyDeclarations)
    }
    
    private func generateTypeDeclaration(for request: Request) -> String {
        return typeDeclarationGenerator.generate(
            keyTypeName: request.keyTypeName,
            accessLevel: request.accessLevel)
    }
    
    private func generateKeyDeclarations(for request: Request) throws -> String {
        let fonts = try fontImporter.import(at: request.fontsURL)
        
        return keyDeclarationGenerator.generate(
            fonts: fonts,
            keyTypeName: request.keyTypeName,
            accessLevel: request.accessLevel)
    }
}
