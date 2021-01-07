import Foundation

protocol AssetCatalogFetcher: AnyObject {
    func fetch(at url: URL, type: AssetType) throws -> AssetCatalog
}

protocol TypeDeclarationGenerator: AnyObject {
    func generate(keyTypeName: String) -> String
}

protocol KeyDeclarationGenerator: AnyObject {
    func generate(from catalog: AssetCatalog, keyTypeName: String) -> String
}

extension AssetKeyGenerator {
    public struct CodeRequest {
        public var assetCatalogURLs: [URL]
        public var assetType: AssetType
        public var keyTypeName: String
        
        public init(assetCatalogURLs: [URL], assetType: AssetType, keyTypeName: String) {
            self.assetCatalogURLs = assetCatalogURLs
            self.assetType = assetType
            self.keyTypeName = keyTypeName
        }
    }
    
    public struct CodeResult {
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
    
    public func generate(for request: CodeRequest) throws -> CodeResult {
        let catalogs: [AssetCatalog] = try request.assetCatalogURLs.map { url in
            try catalogFetcher.fetch(at: url, type: request.assetType)
        }
        
        let typeDeclaration = typeDeclarationGenerator.generate(keyTypeName: request.keyTypeName)
        
        let keyDeclarations = catalogs
            .map({ keyDeclarationGenerator.generate(from: $0, keyTypeName: request.keyTypeName) })
            .joined(separator: "\n\n")
        
        return CodeResult(typeDeclaration: typeDeclaration, keyDeclarations: keyDeclarations)
    }
}
