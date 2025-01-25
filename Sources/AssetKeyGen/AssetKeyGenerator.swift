import Foundation

protocol AssetCatalogImporter: AnyObject {
    func `import`(at url: URL) throws -> AssetCatalog
}

protocol TypeDeclarationGenerator: AnyObject {
    func generate(resourceTypeName: String, accessLevel: String?) -> String
}

protocol KeyDeclarationGenerator: AnyObject {
    func generate(catalog: AssetCatalog, resourceTypeName: String, accessLevel: String?) -> String
}

extension AssetKeyGenerator {
    public struct Request: Sendable {
        public var assetCatalogURLs: [URL]
        public var assetTypes: Set<AssetType>
        public var resourceTypeName: String
        public var accessLevel: String?
        
        public init(assetCatalogURLs: [URL],
                    assetTypes: Set<AssetType>,
                    resourceTypeName: String,
                    accessLevel: String? = nil
        ) {
            self.assetCatalogURLs = assetCatalogURLs
            self.assetTypes = assetTypes
            self.resourceTypeName = resourceTypeName
            self.accessLevel = accessLevel
        }
    }
    
    public struct Result: Sendable {
        public var typeDeclaration: String
        public var keyDeclarations: String
        
        public init(typeDeclaration: String, keyDeclarations: String) {
            self.typeDeclaration = typeDeclaration
            self.keyDeclarations = keyDeclarations
        }
    }
}

public class AssetKeyGenerator {
    private let catalogImporter: AssetCatalogImporter
    private let typeDeclarationGenerator: TypeDeclarationGenerator
    private let keyDeclarationGenerator: KeyDeclarationGenerator
    
    init(catalogImporter: AssetCatalogImporter,
         typeDeclarationGenerator: TypeDeclarationGenerator,
         keyDeclarationGenerator: KeyDeclarationGenerator
    ) {
        self.catalogImporter = catalogImporter
        self.typeDeclarationGenerator = typeDeclarationGenerator
        self.keyDeclarationGenerator = keyDeclarationGenerator
    }
    
    public convenience init() {
        self.init(catalogImporter: DefaultAssetCatalogImporter(),
                  typeDeclarationGenerator: DefaultTypeDeclarationGenerator(),
                  keyDeclarationGenerator: DefaultKeyDeclarationGenerator())
    }
    
    public func generate(for request: Request) throws -> Result {
        let typeDeclaration = generateTypeDeclaration(for: request)
        
        let keyDeclarations = try generateKeyDeclarations(for: request).joined(separator: "\n\n")
        
        return Result(typeDeclaration: typeDeclaration, keyDeclarations: keyDeclarations)
    }
    
    private func generateTypeDeclaration(for request: Request) -> String {
        return typeDeclarationGenerator.generate(resourceTypeName: request.resourceTypeName,
                                                 accessLevel: request.accessLevel)
    }
    
    private func generateKeyDeclarations(for request: Request) throws -> [String] {
        let catalogs: [AssetCatalog] = try request.assetCatalogURLs.map { url in
            var catalog = try catalogImporter.import(at: url)
            catalog.assets.removeAll(where: { !request.assetTypes.contains($0.type) })
            return catalog
        }
        
        return catalogs.map {
            return keyDeclarationGenerator.generate(catalog: $0,
                                                    resourceTypeName: request.resourceTypeName,
                                                    accessLevel: request.accessLevel)
        }
    }
}
