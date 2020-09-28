import XCTest
@testable import AssetKeyGen

class StubAssetCatalogFetcher: AssetCatalogFetcher {
    func fetch(at url: URL, type: AssetType) throws -> AssetCatalog {
        return AssetCatalog(name: "", assets: [])
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
    
    func generate(from catalog: AssetCatalog, keyTypeName: String) -> String {
        return Self.declarationsString
    }
}

class StubKeyListGenerator: KeyListGenerator {
    static let keyListString = "{ Key List }"
    
    func generate(from catalogs: [AssetCatalog], keyTypeName: String) -> String {
        return Self.keyListString
    }
}

final class AssetKeyGeneratorTests: XCTestCase {
    var sut: AssetKeyGenerator!
    
    override func setUpWithError() throws {
        super.setUp()
        
        sut = AssetKeyGenerator(
            catalogFetcher: StubAssetCatalogFetcher(),
            typeDeclarationGenerator: StubTypeDeclarationGenerator(),
            keyDeclarationGenerator: StubKeyDeclarationGenerator(),
            keyListGenerator: StubKeyListGenerator())
    }
    
    func test_generate() throws {
        // Given
        let request = AssetKeyGenerator.Request(
            catalogURLs: [URL(fileURLWithPath: "a"), URL(fileURLWithPath: "b")],
            assetType: .imageSet,
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
        
        XCTAssertEqual(result.keyList, StubKeyListGenerator.keyListString)
    }
}
