import XCTest
@testable import AssetKeyGen

class StubAssetCatalogFetcher: AssetCatalogFetcher {
    func fetch(at url: URL) throws -> AssetCatalog {
        return AssetCatalog(name: "", assets: [
            Asset(name: "image", path: "Images", type: .imageSet),
            Asset(name: "color", path: "Colors", type: .colorSet),
            Asset(name: "symbol", path: "Symbols", type: .symbolSet),
        ])
    }
}

class StubTypeDeclarationGenerator: TypeDeclarationGenerator {
    static let declarationString = "{ Type Declaration }"
    
    func generate(keyTypeName: String) -> String {
        return Self.declarationString
    }
}

class StubKeyDeclarationGenerator: KeyDeclarationGenerator {
    static let declarationsString = "{ Key Declaration }"
    
    var generateParamCatalogs: [AssetCatalog] = []
    
    func generate(from catalog: AssetCatalog, keyTypeName: String) -> String {
        generateParamCatalogs.append(catalog)
        
        return Self.declarationsString
    }
}

final class AssetKeyGeneratorTests: XCTestCase {
    func test_generate_filterAsset() throws {
        // Given
        let keyDeclationGenerator = StubKeyDeclarationGenerator()
        
        let sut = AssetKeyGenerator(
            catalogFetcher: StubAssetCatalogFetcher(),
            typeDeclarationGenerator: StubTypeDeclarationGenerator(),
            keyDeclarationGenerator: keyDeclationGenerator)
        
        let request = AssetKeyGenerator.CodeRequest(
            assetCatalogURLs: [URL(fileURLWithPath: "a"), URL(fileURLWithPath: "b")],
            assetTypes: [.imageSet],
            keyTypeName: "ImageKey")
        
        // When
        _ = try sut.generate(for: request)
        let allAssets = keyDeclationGenerator.generateParamCatalogs.flatMap({ $0.assets })
        
        // Then
        XCTAssert(allAssets.allSatisfy({ $0.type == .imageSet }))
    }
    
    func test_generate_codes() throws {
        // Given
        let keyDeclationGenerator = StubKeyDeclarationGenerator()
        
        let sut = AssetKeyGenerator(
            catalogFetcher: StubAssetCatalogFetcher(),
            typeDeclarationGenerator: StubTypeDeclarationGenerator(),
            keyDeclarationGenerator: keyDeclationGenerator)
        
        let request = AssetKeyGenerator.CodeRequest(
            assetCatalogURLs: [URL(fileURLWithPath: "a"), URL(fileURLWithPath: "b")],
            assetTypes: [.imageSet],
            keyTypeName: "ImageKey")
        
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
}
