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

protocol KeyListGenerator: AnyObject {
    func generate(from catalogs: [AssetCatalog], keyTypeName: String) -> String
}

public extension AssetKeyGenerator {
    struct Request {
        var catalogURLs: [URL]
        var assetType: AssetType
        var keyTypeName: String
    }
    
    struct Result {
        var typeDeclaration: String
        var keyDeclarations: String
        var keyList: String
    }
}

public class AssetKeyGenerator {
    private let catalogFetcher: AssetCatalogFetcher
    private let typeDeclarationGenerator: TypeDeclarationGenerator
    private let keyDeclarationGenerator: KeyDeclarationGenerator
    private let keyListGenerator: KeyListGenerator
    
    init(catalogFetcher: AssetCatalogFetcher,
         typeDeclarationGenerator: TypeDeclarationGenerator,
         keyDeclarationGenerator: KeyDeclarationGenerator,
         keyListGenerator: KeyListGenerator
    ) {
        self.catalogFetcher = catalogFetcher
        self.typeDeclarationGenerator = typeDeclarationGenerator
        self.keyDeclarationGenerator = keyDeclarationGenerator
        self.keyListGenerator = keyListGenerator
    }
    
    public convenience init() {
        self.init(catalogFetcher: ActualAssetCatalogFetcher(),
                  typeDeclarationGenerator: ActualTypeDeclarationGenerator(),
                  keyDeclarationGenerator: ActualKeyDeclarationGenerator(),
                  keyListGenerator: ActualKeyListGenerator())
    }
    
    public func generate(for request: Request) throws -> Result {
        let catalogs: [AssetCatalog] = try request.catalogURLs.map { url in
            try catalogFetcher.fetch(at: url, type: request.assetType)
        }
        
        let typeDeclaration = typeDeclarationGenerator.generate(keyTypeName: request.keyTypeName)
        
        let keyDeclarations = catalogs.reduce(into: "") { ret, catalog in
            ret += keyDeclarationGenerator.generate(from: catalog, keyTypeName: request.keyTypeName)
        }
        
        let keyList = keyListGenerator.generate(from: catalogs, keyTypeName: request.keyTypeName)
        
        return Result(typeDeclaration: typeDeclaration,
                      keyDeclarations: keyDeclarations,
                      keyList: keyList)
    }
}
