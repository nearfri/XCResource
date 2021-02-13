import XCTest
@testable import AssetKeyGen

private class StubAssetCatalogFetcher: AssetCatalogFetcher {
    func fetch(at url: URL) throws -> AssetCatalog {
        return AssetCatalog(name: "", assets: [
            Asset(name: "image", path: "Images", type: .imageSet),
            Asset(name: "color", path: "Colors", type: .colorSet),
            Asset(name: "symbol", path: "Symbols", type: .symbolSet),
        ])
    }
}

private class StubTypeDeclarationGenerator: TypeDeclarationGenerator {
    static let declarationString = "{ Type Declaration }"
    
    func generate(keyTypeName: String) -> String {
        return Self.declarationString
    }
}

private class StubKeyDeclarationGenerator: KeyDeclarationGenerator {
    static let declarationsString = "{ Key Declaration }"
    
    var generateParamCatalogs: [AssetCatalog] = []
    
    func generate(catalog: AssetCatalog, keyTypeName: String) -> String {
        generateParamCatalogs.append(catalog)
        
        return Self.declarationsString
    }
}

final class AssetKeyGeneratorTests: XCTestCase {
    private var keyDeclationGenerator: StubKeyDeclarationGenerator!
    private var request: AssetKeyGenerator.Request!
    private var sut: AssetKeyGenerator!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        keyDeclationGenerator = StubKeyDeclarationGenerator()
        
        request = AssetKeyGenerator.Request(
            assetCatalogURLs: [URL(fileURLWithPath: "a"), URL(fileURLWithPath: "b")],
            assetTypes: [.imageSet],
            keyTypeName: "ImageKey")
        
        sut = AssetKeyGenerator(
            catalogFetcher: StubAssetCatalogFetcher(),
            typeDeclarationGenerator: StubTypeDeclarationGenerator(),
            keyDeclarationGenerator: keyDeclationGenerator)
    }
    
    func test_generate_codes() throws {
        // When
        let result = try sut.generate(for: request)
        
        // Then
        XCTAssertEqual(result.typeDeclaration, StubTypeDeclarationGenerator.declarationString)
        
        XCTAssertEqual(
            result.keyDeclarations,
            """
            \(StubKeyDeclarationGenerator.declarationsString)
            
            \(StubKeyDeclarationGenerator.declarationsString)
            """
        )
    }
    
    func test_generate_filterAsset() throws {
        // When
        _ = try sut.generate(for: request)
        let allAssets = keyDeclationGenerator.generateParamCatalogs.flatMap({ $0.assets })
        
        // Then
        XCTAssert(allAssets.allSatisfy({ $0.type == .imageSet }))
    }
}
