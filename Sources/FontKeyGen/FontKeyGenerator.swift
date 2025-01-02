import Foundation

protocol FontImporter: AnyObject {
    func `import`(at url: URL) throws -> [Font]
}

protocol TypeDeclarationGenerator: AnyObject {
    func generate(keyTypeName: String, accessLevel: String?) -> String
}

struct KeyDeclarationRequest: Sendable {
    var fonts: [Font]
    var keyTypeName: String
    var keyListName: String?
    var generatesLatinKey: Bool
    var stripsCombiningMarksFromKey: Bool
    var preservesRelativePath: Bool
    var relativePathPrefix: String?
    var bundle: String
    var accessLevel: String?
}

protocol KeyDeclarationGenerator: AnyObject {
    func generateKeyListDeclaration(for request: KeyDeclarationRequest) -> String?
    func generateKeyDeclarations(for request: KeyDeclarationRequest) -> String
}

extension FontKeyGenerator {
    public struct Request: Sendable {
        public var resourcesURL: URL
        public var keyTypeName: String
        public var keyListName: String?
        public var generatesLatinKey: Bool
        public var stripsCombiningMarksFromKey: Bool
        public var preservesRelativePath: Bool
        public var relativePathPrefix: String?
        public var bundle: String
        public var accessLevel: String?
        
        public init(
            resourcesURL: URL,
            keyTypeName: String,
            keyListName: String?,
            generatesLatinKey: Bool,
            stripsCombiningMarksFromKey: Bool,
            preservesRelativePath: Bool,
            relativePathPrefix: String?,
            bundle: String,
            accessLevel: String? = nil
        ) {
            self.resourcesURL = resourcesURL
            self.keyTypeName = keyTypeName
            self.keyListName = keyListName
            self.generatesLatinKey = generatesLatinKey
            self.stripsCombiningMarksFromKey = stripsCombiningMarksFromKey
            self.preservesRelativePath = preservesRelativePath
            self.relativePathPrefix = relativePathPrefix
            self.bundle = bundle
            self.accessLevel = accessLevel
        }
    }
    
    public struct Result: Sendable {
        public var typeDeclaration: String
        public var keyListDeclaration: String?
        public var keyDeclarations: String
        
        public init(typeDeclaration: String, keyListDeclaration: String?, keyDeclarations: String) {
            self.typeDeclaration = typeDeclaration
            self.keyListDeclaration = keyListDeclaration
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
        let fonts = try fontImporter.import(at: request.resourcesURL)
        
        let typeDeclaration = typeDeclarationGenerator.generate(
            keyTypeName: request.keyTypeName,
            accessLevel: request.accessLevel)
        
        let keyRequest = KeyDeclarationRequest(
            fonts: fonts,
            keyTypeName: request.keyTypeName,
            keyListName: request.keyListName,
            generatesLatinKey: request.generatesLatinKey,
            stripsCombiningMarksFromKey: request.stripsCombiningMarksFromKey,
            preservesRelativePath: request.preservesRelativePath,
            relativePathPrefix: request.relativePathPrefix,
            bundle: request.bundle,
            accessLevel: request.accessLevel)
        
        let keyListDeclaration = keyDeclarationGenerator.generateKeyListDeclaration(for: keyRequest)
        
        let keyDeclarations = keyDeclarationGenerator.generateKeyDeclarations(for: keyRequest)
        
        return Result(typeDeclaration: typeDeclaration,
                      keyListDeclaration: keyListDeclaration,
                      keyDeclarations: keyDeclarations)
    }
}
