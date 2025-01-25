import Foundation

protocol FontImporter: AnyObject {
    func `import`(at url: URL) throws -> [Font]
}

protocol TypeDeclarationGenerator: AnyObject {
    func generate(resourceTypeName: String, accessLevel: String?) -> String
}

struct KeyDeclarationRequest: Sendable {
    var fonts: [Font]
    var resourceTypeName: String
    var resourceListName: String?
    var transformsToLatin: Bool
    var stripsCombiningMarks: Bool
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
        public var resourceTypeName: String
        public var resourceListName: String?
        public var transformsToLatin: Bool
        public var stripsCombiningMarks: Bool
        public var preservesRelativePath: Bool
        public var relativePathPrefix: String?
        public var bundle: String
        public var accessLevel: String?
        
        public init(
            resourcesURL: URL,
            resourceTypeName: String,
            resourceListName: String?,
            transformsToLatin: Bool,
            stripsCombiningMarks: Bool,
            preservesRelativePath: Bool,
            relativePathPrefix: String?,
            bundle: String,
            accessLevel: String? = nil
        ) {
            self.resourcesURL = resourcesURL
            self.resourceTypeName = resourceTypeName
            self.resourceListName = resourceListName
            self.transformsToLatin = transformsToLatin
            self.stripsCombiningMarks = stripsCombiningMarks
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
            resourceTypeName: request.resourceTypeName,
            accessLevel: request.accessLevel)
        
        let keyRequest = KeyDeclarationRequest(
            fonts: fonts,
            resourceTypeName: request.resourceTypeName,
            resourceListName: request.resourceListName,
            transformsToLatin: request.transformsToLatin,
            stripsCombiningMarks: request.stripsCombiningMarks,
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
