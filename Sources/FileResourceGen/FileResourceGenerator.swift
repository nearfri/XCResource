import Foundation

protocol FileTreeGenerator: AnyObject {
    func load(at url: URL) throws -> FileTree
}

protocol TypeDeclarationGenerator: AnyObject {
    func generate(resourceTypeName: String, accessLevel: String?) -> String
}

struct ValueDeclarationRequest {
    var fileTree: FileTree
    var resourceTypeName: String
    var preservesRelativePath: Bool
    var relativePathPrefix: String?
    var bundle: String
    var accessLevel: String?
}

protocol ValueDeclarationGenerator: AnyObject {
    func generateValueDeclarations(for request: ValueDeclarationRequest) -> String
}

extension FileResourceGenerator {
    public struct Request: Sendable {
        public var resourcesURL: URL
        public var filePattern: String
        public var resourceTypeName: String
        public var preservesRelativePath: Bool
        public var relativePathPrefix: String?
        public var bundle: String
        public var accessLevel: String?
        
        public init(
            resourcesURL: URL,
            filePattern: String,
            resourceTypeName: String,
            preservesRelativePath: Bool,
            relativePathPrefix: String?,
            bundle: String,
            accessLevel: String? = nil
        ) {
            self.resourcesURL = resourcesURL
            self.filePattern = filePattern
            self.resourceTypeName = resourceTypeName
            self.preservesRelativePath = preservesRelativePath
            self.relativePathPrefix = relativePathPrefix
            self.bundle = bundle
            self.accessLevel = accessLevel
        }
    }
    
    public struct Result: Sendable {
        public var typeDeclaration: String
        public var valueDeclarations: String
        
        public init(typeDeclaration: String, valueDeclarations: String) {
            self.typeDeclaration = typeDeclaration
            self.valueDeclarations = valueDeclarations
        }
    }
}

public class FileResourceGenerator {
    private let fileTreeGenerator: FileTreeGenerator
    private let typeDeclarationGenerator: TypeDeclarationGenerator
    private let valueDeclarationGenerator: ValueDeclarationGenerator
    
    init(fileTreeGenerator: FileTreeGenerator, 
         typeDeclarationGenerator: TypeDeclarationGenerator,
         valueDeclarationGenerator: ValueDeclarationGenerator
    ) {
        self.fileTreeGenerator = fileTreeGenerator
        self.typeDeclarationGenerator = typeDeclarationGenerator
        self.valueDeclarationGenerator = valueDeclarationGenerator
    }
    
    public convenience init() {
        self.init(fileTreeGenerator: DefaultFileTreeGenerator(),
                  typeDeclarationGenerator: DefaultTypeDeclarationGenerator(),
                  valueDeclarationGenerator: DefaultValueDeclarationGenerator())
    }
    
    public func generate(for request: Request) throws -> Result {
        let fileTree = try fileTreeGenerator.load(at: request.resourcesURL)
        let filteredFileTree = fileTree.filter(try Regex(request.filePattern))
        
        let typeDeclaration = typeDeclarationGenerator.generate(
            resourceTypeName: request.resourceTypeName,
            accessLevel: request.accessLevel)
        
        let valueRequest = ValueDeclarationRequest(
            fileTree: filteredFileTree ?? FileTree(FileItem(url: request.resourcesURL)),
            resourceTypeName: request.resourceTypeName,
            preservesRelativePath: request.preservesRelativePath,
            relativePathPrefix: request.relativePathPrefix,
            bundle: request.bundle,
            accessLevel: request.accessLevel)
        
        let valueDeclarations = valueDeclarationGenerator
            .generateValueDeclarations(for: valueRequest)
        
        return Result(typeDeclaration: typeDeclaration,
                      valueDeclarations: valueDeclarations)
    }
}
