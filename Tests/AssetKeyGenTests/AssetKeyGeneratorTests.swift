import Testing
import Foundation
@testable import AssetKeyGen

private class StubAssetCatalogImporter: AssetCatalogImporter {
    func `import`(at url: URL) throws -> AssetCatalog {
        return AssetCatalog(name: "", assets: [
            Asset(name: "image", path: "Images", type: .imageSet),
            Asset(name: "color", path: "Colors", type: .colorSet),
            Asset(name: "symbol", path: "Symbols", type: .symbolSet),
        ])
    }
}

private class StubTypeDeclarationGenerator: TypeDeclarationGenerator {
    static let declarationString = "{ Type Declaration }"
    
    func generate(resourceTypeName: String, accessLevel: String?) -> String {
        return Self.declarationString
    }
}

private class StubKeyDeclarationGenerator: KeyDeclarationGenerator {
    static let declarationsString = "{ Key Declaration }"
    
    var generateParamCatalogs: [AssetCatalog] = []
    
    func generate(catalog: AssetCatalog, resourceTypeName: String, accessLevel: String?) -> String {
        generateParamCatalogs.append(catalog)
        
        return Self.declarationsString
    }
}

@Suite struct AssetKeyGeneratorTests {
    private let keyDeclarationGenerator: StubKeyDeclarationGenerator = .init()
    
    private let request: AssetKeyGenerator.Request = AssetKeyGenerator.Request(
        assetCatalogURLs: [URL(fileURLWithPath: "a"), URL(fileURLWithPath: "b")],
        assetTypes: [.imageSet],
        resourceTypeName: "ImageKey",
        accessLevel: nil)
    
    private let sut: AssetKeyGenerator
    
    init() {
        sut = AssetKeyGenerator(
            catalogImporter: StubAssetCatalogImporter(),
            typeDeclarationGenerator: StubTypeDeclarationGenerator(),
            keyDeclarationGenerator: keyDeclarationGenerator)
    }
    
    @Test func generate_codes() throws {
        // When
        let result = try sut.generate(for: request)
        
        // Then
        #expect(result.typeDeclaration == StubTypeDeclarationGenerator.declarationString)
        
        #expect(result.keyDeclarations == """
            \(StubKeyDeclarationGenerator.declarationsString)
            
            \(StubKeyDeclarationGenerator.declarationsString)
            """
        )
    }
    
    @Test func generate_filterAsset() throws {
        // When
        _ = try sut.generate(for: request)
        let allAssets = keyDeclarationGenerator.generateParamCatalogs.flatMap({ $0.assets })
        
        // Then
        #expect(allAssets.allSatisfy({ $0.type == .imageSet }))
    }
}
