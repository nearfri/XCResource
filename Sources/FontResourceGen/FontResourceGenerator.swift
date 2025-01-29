import Foundation

protocol FontImporter: AnyObject {
    func `import`(at url: URL) throws -> [Font]
}

protocol TypeDeclarationGenerator: AnyObject {
    func generate(resourceTypeName: String, accessLevel: String?) -> String
}

struct ValueDeclarationRequest: Sendable {
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

protocol ValueDeclarationGenerator: AnyObject {
    func generateValueListDeclaration(for request: ValueDeclarationRequest) -> String?
    func generateValueDeclarations(for request: ValueDeclarationRequest) -> String
}

extension FontResourceGenerator {
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
        public var valueListDeclaration: String?
        public var valueDeclarations: String
        
        public init(
            typeDeclaration: String,
            valueListDeclaration: String?,
            valueDeclarations: String
        ) {
            self.typeDeclaration = typeDeclaration
            self.valueListDeclaration = valueListDeclaration
            self.valueDeclarations = valueDeclarations
        }
    }
}

public class FontResourceGenerator {
    private let fontImporter: FontImporter
    private let typeDeclarationGenerator: TypeDeclarationGenerator
    private let valueDeclarationGenerator: ValueDeclarationGenerator
    
    init(fontImporter: FontImporter,
         typeDeclarationGenerator: TypeDeclarationGenerator,
         valueDeclarationGenerator: ValueDeclarationGenerator
    ) {
        self.fontImporter = fontImporter
        self.typeDeclarationGenerator = typeDeclarationGenerator
        self.valueDeclarationGenerator = valueDeclarationGenerator
    }
    
    public convenience init() {
        self.init(fontImporter: DefaultFontImporter(),
                  typeDeclarationGenerator: DefaultTypeDeclarationGenerator(),
                  valueDeclarationGenerator: DefaultValueDeclarationGenerator())
    }
    
    public func generate(for request: Request) throws -> Result {
        let fonts = try fontImporter.import(at: request.resourcesURL)
        
        let typeDeclaration = typeDeclarationGenerator.generate(
            resourceTypeName: request.resourceTypeName,
            accessLevel: request.accessLevel)
        
        let valueRequest = ValueDeclarationRequest(
            fonts: fonts,
            resourceTypeName: request.resourceTypeName,
            resourceListName: request.resourceListName,
            transformsToLatin: request.transformsToLatin,
            stripsCombiningMarks: request.stripsCombiningMarks,
            preservesRelativePath: request.preservesRelativePath,
            relativePathPrefix: request.relativePathPrefix,
            bundle: request.bundle,
            accessLevel: request.accessLevel)
        
        let listDeclaration = valueDeclarationGenerator
            .generateValueListDeclaration(for: valueRequest)
        
        let valueDeclarations = valueDeclarationGenerator
            .generateValueDeclarations(for: valueRequest)
        
        return Result(typeDeclaration: typeDeclaration,
                      valueListDeclaration: listDeclaration,
                      valueDeclarations: valueDeclarations)
    }
}
