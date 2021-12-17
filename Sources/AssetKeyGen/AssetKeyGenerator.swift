import Foundation

protocol AssetCatalogImporter: AnyObject {
    func `import`(at url: URL) throws -> AssetCatalog
}

protocol TypeDeclarationGenerator: AnyObject {
    func generate(keyTypeName: String, accessLevel: String?) -> String
}

protocol KeyDeclarationGenerator: AnyObject {
    func generate(catalog: AssetCatalog, keyTypeName: String, accessLevel: String?) -> String
}

extension AssetKeyGenerator {
    public struct Request {
        public var assetCatalogURLs: [URL]
        public var assetTypes: Set<AssetType>
        public var keyTypeName: String
        public var accessLevel: String?
        
        public init(assetCatalogURLs: [URL],
                    assetTypes: Set<AssetType>,
                    keyTypeName: String,
                    accessLevel: String? = nil
        ) {
            self.assetCatalogURLs = assetCatalogURLs
            self.assetTypes = assetTypes
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
        let typeDeclaration = generateTypeDeclation(for: request)
        
        let keyDeclarations = try generateKeyDeclations(for: request).joined(separator: "\n\n")
        
        return Result(typeDeclaration: typeDeclaration, keyDeclarations: keyDeclarations)
    }
    
    private func generateTypeDeclation(for request: Request) -> String {
        return typeDeclarationGenerator.generate(keyTypeName: request.keyTypeName,
                                                 accessLevel: request.accessLevel)
    }
    
    private func generateKeyDeclations(for request: Request) throws -> [String] {
        let catalogs: [AssetCatalog] = try request.assetCatalogURLs.map { url in
            var catalog = try catalogImporter.import(at: url)
            catalog.assets.removeAll(where: { !request.assetTypes.contains($0.type) })
            return catalog
        }
        
        return catalogs.map {
            return keyDeclarationGenerator.generate(catalog: $0,
                                                    keyTypeName: request.keyTypeName,
                                                    accessLevel: request.accessLevel)
        }
    }
}
