import Testing
import SampleData
@testable import AssetResourceGen

@Suite struct ContentTreeGeneratorTests {
    @Test func load_root() throws {
        // Given
        let url = SampleData.assetURL()
        
        // When
        let root = try DefaultContentTreeGenerator().load(at: url)
        
        // Then
        #expect(root.isRoot)
        #expect(root.hasChildren)
        #expect(root.element.name == url.lastPathComponent)
        #expect(root.element.type == .group)
        #expect(root.element.providesNamespace == false)
    }
    
    @Test func load_childFolder() throws {
        // Given
        let url = SampleData.assetURL()
        
        // When
        let root = try DefaultContentTreeGenerator().load(at: url)
        let c1 = try #require(root.children.first(where: { $0.element.name == "Places" }))
        let c2 = try #require(c1.children.first(where: { $0.element.name == "Dot" }))
        
        // Then
        #expect(!c1.isRoot)
        #expect(!c2.isRoot)
        
        #expect(c1.hasChildren)
        #expect(c2.hasChildren)
        
        #expect(c1.element.name == "Places")
        #expect(c2.element.name == "Dot")
        
        #expect(c1.element.type == .group)
        #expect(c2.element.type == .group)
        
        #expect(c1.element.providesNamespace == false)
        #expect(c2.element.providesNamespace == true)
    }
    
    @Test func load_imageSet() throws {
        // Given
        let url = SampleData.assetURL()
        
        // When
        let root = try DefaultContentTreeGenerator().load(at: url)
        let folder = try #require(root.children.first(where: { $0.element.name == "Settings" }))
        let image = try #require(folder.children.first(where: { $0.element.name == "settings" }))
        
        // Then
        #expect(!image.hasChildren)
        #expect(image.element.name == "settings")
        #expect(image.element.type == .asset(.imageSet))
        #expect(image.element.providesNamespace == false)
    }
    
    @Test func load_colorSet() throws {
        // Given
        let url = SampleData.assetURL()
        
        // When
        let root = try DefaultContentTreeGenerator().load(at: url)
        let folder = try #require(root.children.first(where: { $0.element.name == "Color" }))
        let color = try #require(folder.children.first(where: { $0.element.name == "blush" }))
        
        // Then
        #expect(!color.hasChildren)
        #expect(color.element.name == "blush")
        #expect(color.element.type == .asset(.colorSet))
        #expect(color.element.providesNamespace == false)
    }
}
