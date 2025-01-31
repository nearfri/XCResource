import Testing
import Foundation
@testable import AssetResourceGen

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

private class StubValueDeclarationGenerator: ValueDeclarationGenerator {
    static let declarationsString = "{ Key Declaration }"
    
    var generateParamCatalogs: [AssetCatalog] = []
    
    func generate(catalog: AssetCatalog, resourceTypeName: String, accessLevel: String?) -> String {
        generateParamCatalogs.append(catalog)
        
        return Self.declarationsString
    }
}

@Suite struct AssetResourceGeneratorTests {
    private let valueDeclarationGenerator: StubValueDeclarationGenerator = .init()
    
    private let request: AssetResourceGenerator.Request = AssetResourceGenerator.Request(
        assetCatalogURLs: [URL(filePath: "a"), URL(filePath: "b")],
        assetTypes: [.imageSet],
        resourceTypeName: "ImageKey",
        accessLevel: nil)
    
    private let sut: AssetResourceGenerator
    
    init() {
        sut = AssetResourceGenerator(
            catalogImporter: StubAssetCatalogImporter(),
            typeDeclarationGenerator: StubTypeDeclarationGenerator(),
            valueDeclarationGenerator: valueDeclarationGenerator)
    }
    
    @Test func generate_codes() throws {
        // When
        let result = try sut.generate(for: request)
        
        // Then
        #expect(result.typeDeclaration == StubTypeDeclarationGenerator.declarationString)
        
        #expect(result.valueDeclarations == """
            \(StubValueDeclarationGenerator.declarationsString)
            
            \(StubValueDeclarationGenerator.declarationsString)
            """
        )
    }
    
    @Test func generate_filterAsset() throws {
        // When
        _ = try sut.generate(for: request)
        let allAssets = valueDeclarationGenerator.generateParamCatalogs.flatMap({ $0.assets })
        
        // Then
        #expect(allAssets.allSatisfy({ $0.type == .imageSet }))
    }
}
