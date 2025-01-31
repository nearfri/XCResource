import Testing
import Foundation
@testable import AssetResourceGen

private class StubContentTreeGenerator: ContentTreeGenerator {
    var loadCalledCount = 0
    
    func load(at url: URL) throws -> ContentTree {
        loadCalledCount += 1
        
        return ContentTree(try Content(url: url), children: [
            ContentTree(try Content(url: URL(filePath: "image\(loadCalledCount).imageset"))),
            ContentTree(try Content(url: URL(filePath: "color\(loadCalledCount).colorset"))),
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
    static let declarationsString = "{ Value Declarations }"
    
    var generateParamContentTree: ContentTree?
    
    func generate(for request: ValueDeclarationRequest) -> String {
        generateParamContentTree = request.contentTree
        return Self.declarationsString
    }
}

@Suite struct AssetResourceGeneratorTests {
    private let valueDeclarationGenerator: StubValueDeclarationGenerator = .init()
    
    private let request: AssetResourceGenerator.Request = AssetResourceGenerator.Request(
        assetCatalogURLs: [URL(filePath: "a"), URL(filePath: "b")],
        assetTypes: [.imageSet],
        resourceTypeName: "ImageKey",
        bundle: "Bundle.main",
        accessLevel: nil)
    
    private let sut: AssetResourceGenerator
    
    init() {
        sut = AssetResourceGenerator(
            contentTreeGenerator: StubContentTreeGenerator(),
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
        
        let contentTree = try #require(valueDeclarationGenerator.generateParamContentTree)
        
        // Then
        #expect(contentTree.makePreOrderSequence().allSatisfy({
            switch $0.element.type {
            case .group: return true
            case .asset(let assetType): return assetType == .imageSet
            }
        }))
    }
}
