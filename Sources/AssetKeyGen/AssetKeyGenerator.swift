import Foundation

protocol AssetCatalogFetcher: AnyObject {
    func fetch(at url: URL) throws -> AssetCatalog
}

protocol TypeDeclarationGenerator: AnyObject {
    func generate(keyTypeName: String) -> String
}

protocol KeyDeclarationGenerator: AnyObject {
    func generate(catalog: AssetCatalog, keyTypeName: String) -> String
}

extension AssetKeyGenerator {
    public struct Request {
        public var assetCatalogURLs: [URL]
        public var assetTypes: Set<AssetType>
        public var keyTypeName: String
        
        public init(assetCatalogURLs: [URL], assetTypes: Set<AssetType>, keyTypeName: String) {
            self.assetCatalogURLs = assetCatalogURLs
            self.assetTypes = assetTypes
            self.keyTypeName = keyTypeName
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
    private let catalogFetcher: AssetCatalogFetcher
    private let typeDeclarationGenerator: TypeDeclarationGenerator
    private let keyDeclarationGenerator: KeyDeclarationGenerator
    
    init(catalogFetcher: AssetCatalogFetcher,
         typeDeclarationGenerator: TypeDeclarationGenerator,
         keyDeclarationGenerator: KeyDeclarationGenerator
    ) {
        self.catalogFetcher = catalogFetcher
        self.typeDeclarationGenerator = typeDeclarationGenerator
        self.keyDeclarationGenerator = keyDeclarationGenerator
    }
    
    public convenience init() {
        self.init(catalogFetcher: ActualAssetCatalogFetcher(),
                  typeDeclarationGenerator: ActualTypeDeclarationGenerator(),
                  keyDeclarationGenerator: ActualKeyDeclarationGenerator())
    }
    
    public func generate(for request: Request) throws -> Result {
        let typeDeclaration = generateTypeDeclation(for: request)
        
        let keyDeclarations = try generateKeyDeclations(for: request).joined(separator: "\n\n")
        
        return Result(typeDeclaration: typeDeclaration, keyDeclarations: keyDeclarations)
    }
    
    private func generateTypeDeclation(for request: Request) -> String {
        return typeDeclarationGenerator.generate(keyTypeName: request.keyTypeName)
    }
    
    private func generateKeyDeclations(for request: Request) throws -> [String] {
        let catalogs: [AssetCatalog] = try request.assetCatalogURLs.map { url in
            var catalog = try catalogFetcher.fetch(at: url)
            catalog.assets.removeAll(where: { !request.assetTypes.contains($0.type) })
            return catalog
        }
        
        return catalogs.map {
            return keyDeclarationGenerator.generate(catalog: $0, keyTypeName: request.keyTypeName)
        }
    }
}
