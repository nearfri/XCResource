import Foundation

protocol FontImporter: AnyObject {
    func `import`(at url: URL) throws -> [Font]
}

protocol TypeDeclarationGenerator: AnyObject {
    func generate(keyTypeName: String, accessLevel: String?) -> String
}

struct KeyDeclarationRequest {
    var fonts: [Font]
    var keyTypeName: String
    var accessLevel: String?
}

protocol KeyDeclarationGenerator: AnyObject {
    func generateAllKeysDeclaration(for request: KeyDeclarationRequest) -> String
    func generateKeyDeclarations(for request: KeyDeclarationRequest) -> String
}

extension FontKeyGenerator {
    public struct Request {
        public var fontsURL: URL
        public var keyTypeName: String
        public var accessLevel: String?
        
        public init(fontsURL: URL, keyTypeName: String, accessLevel: String? = nil) {
            self.fontsURL = fontsURL
            self.keyTypeName = keyTypeName
            self.accessLevel = accessLevel
        }
    }
    
    public struct Result {
        public var typeDeclaration: String
        public var allKeysDeclaration: String
        public var keyDeclarations: String
        
        public init(typeDeclaration: String, allKeysDeclaration: String, keyDeclarations: String) {
            self.typeDeclaration = typeDeclaration
            self.allKeysDeclaration = allKeysDeclaration
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
        let fonts = try fontImporter.import(at: request.fontsURL)
        
        let typeDeclaration = typeDeclarationGenerator.generate(
            keyTypeName: request.keyTypeName,
            accessLevel: request.accessLevel)
        
        let keyRequest = KeyDeclarationRequest(
            fonts: fonts,
            keyTypeName: request.keyTypeName,
            accessLevel: request.accessLevel)
        
        let allKeysDeclaration = keyDeclarationGenerator.generateAllKeysDeclaration(for: keyRequest)
        
        let keyDeclarations = keyDeclarationGenerator.generateKeyDeclarations(for: keyRequest)
        
        return Result(typeDeclaration: typeDeclaration,
                      allKeysDeclaration: allKeysDeclaration,
                      keyDeclarations: keyDeclarations)
    }
}
