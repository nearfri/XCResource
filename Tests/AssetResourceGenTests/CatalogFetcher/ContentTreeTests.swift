import Testing
import Foundation
@testable import AssetResourceGen

@Suite struct ContentTreeTests {
    @Test func fullName_noNamespace() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: false))
        let child = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child"),
                type: .group,
                providesNamespace: false))
        let grandchild = ContentTree(
            Content(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        #expect(root.fullName == "root")
        #expect(child.fullName == "child")
        #expect(grandchild.fullName == "grandchild")
    }
    
    @Test func fullName_rootNamespace() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: true))
        let child = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child"),
                type: .group,
                providesNamespace: false))
        let grandchild = ContentTree(
            Content(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        #expect(root.fullName == "root")
        #expect(child.fullName == "root/child")
        #expect(grandchild.fullName == "root/grandchild")
    }
    
    @Test func fullName_childNamespace() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: false))
        let child = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child"),
                type: .group,
                providesNamespace: true))
        let grandchild = ContentTree(
            Content(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        #expect(root.fullName == "root")
        #expect(child.fullName == "child")
        #expect(grandchild.fullName == "child/grandchild")
    }
    
    @Test func fullName_rootAndChildNamespace() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: true))
        let child = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child"),
                type: .group,
                providesNamespace: true))
        let grandchild = ContentTree(
            Content(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        #expect(root.fullName == "root")
        #expect(child.fullName == "root/child")
        #expect(grandchild.fullName == "root/child/grandchild")
    }
    
    @Test func relativePath() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: false))
        let child = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child"),
                type: .group,
                providesNamespace: false))
        let grandchild = ContentTree(
            Content(
                url: URL(fileURLWithPath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        #expect(root.relativePath == "")
        #expect(child.relativePath == "child")
        #expect(grandchild.relativePath == "child/grandchild.imageset")
    }
    
    @Test func toAsset_whenGroup_returnNil() {
        // Given
        let contentTree = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: false))
        
        // When
        let asset = contentTree.toAsset()
        
        // Then
        #expect(asset == nil)
    }
    
    @Test func toAsset_whenAsset_returnAsset() throws {
        // Given
        let root = ContentTree(
            Content(
                url: URL(fileURLWithPath: "root"),
                type: .group,
                providesNamespace: false))
        let child = ContentTree(
            Content(
                url: URL(fileURLWithPath: "child.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        
        // When
        let asset = child.toAsset()
        
        // Then
        let unwrappedAsset = try #require(asset)
        #expect(unwrappedAsset.name == "child")
        #expect(unwrappedAsset.path == "child.imageset")
        #expect(unwrappedAsset.type == .imageSet)
    }
}
