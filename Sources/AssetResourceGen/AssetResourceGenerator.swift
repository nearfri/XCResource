import Foundation

protocol ContentTreeGenerator: AnyObject {
    func load(at url: URL) throws -> ContentTree
}

protocol TypeDeclarationGenerator: AnyObject {
    func generate(resourceTypeName: String, accessLevel: String?) -> String
}

struct ValueDeclarationRequest {
    var contentTree: ContentTree
    var resourceTypeName: String
    var bundle: String
    var accessLevel: String?
}

protocol ValueDeclarationGenerator: AnyObject {
    func generate(for request: ValueDeclarationRequest) -> String
}

extension AssetResourceGenerator {
    public struct Request: Sendable {
        public var assetCatalogURLs: [URL]
        public var assetTypes: Set<AssetType>
        public var resourceTypeName: String
        public var bundle: String
        public var accessLevel: String?
        
        public init(assetCatalogURLs: [URL],
                    assetTypes: Set<AssetType>,
                    resourceTypeName: String,
                    bundle: String,
                    accessLevel: String? = nil
        ) {
            self.assetCatalogURLs = assetCatalogURLs
            self.assetTypes = assetTypes
            self.resourceTypeName = resourceTypeName
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

public class AssetResourceGenerator {
    private let contentTreeGenerator: ContentTreeGenerator
    private let typeDeclarationGenerator: TypeDeclarationGenerator
    private let valueDeclarationGenerator: ValueDeclarationGenerator
    
    init(contentTreeGenerator: ContentTreeGenerator,
         typeDeclarationGenerator: TypeDeclarationGenerator,
         valueDeclarationGenerator: ValueDeclarationGenerator
    ) {
        self.contentTreeGenerator = contentTreeGenerator
        self.typeDeclarationGenerator = typeDeclarationGenerator
        self.valueDeclarationGenerator = valueDeclarationGenerator
    }
    
    public convenience init() {
        self.init(contentTreeGenerator: DefaultContentTreeGenerator(),
                  typeDeclarationGenerator: DefaultTypeDeclarationGenerator(),
                  valueDeclarationGenerator: DefaultValueDeclarationGenerator())
    }
    
    public func generate(for request: Request) throws -> Result {
        let typeDeclaration = generateTypeDeclaration(for: request)
        
        let valueDeclarations = try generateValueDeclarations(for: request)
            .joined(separator: "\n\n")
        
        return Result(typeDeclaration: typeDeclaration, valueDeclarations: valueDeclarations)
    }
    
    private func generateTypeDeclaration(for request: Request) -> String {
        return typeDeclarationGenerator.generate(resourceTypeName: request.resourceTypeName,
                                                 accessLevel: request.accessLevel)
    }
    
    private func generateValueDeclarations(for request: Request) throws -> [String] {
        return try request
            .assetCatalogURLs
            .map { url in
                try contentTreeGenerator.load(at: url)
            }
            .compactMap { contentTree in
                contentTree.filter(matching: request.assetTypes)
            }
            .filter({ $0.hasChildren })
            .map { contentTree in
                ValueDeclarationRequest(
                    contentTree: contentTree,
                    resourceTypeName: request.resourceTypeName,
                    bundle: request.bundle,
                    accessLevel: request.accessLevel)
            }
            .map { valueRequest in
                valueDeclarationGenerator.generate(for: valueRequest)
            }
    }
}
