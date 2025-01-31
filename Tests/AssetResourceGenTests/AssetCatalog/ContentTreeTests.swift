import Testing
import Foundation
@testable import AssetResourceGen

@Suite struct ContentTreeTests {
    @Test func name_noNamespace() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(filePath: "root"),
                type: .group,
                providesNamespace: false))
        let child = ContentTree(
            Content(
                url: URL(filePath: "child"),
                type: .group,
                providesNamespace: false))
        let grandchild = ContentTree(
            Content(
                url: URL(filePath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        #expect(root.name == "root")
        #expect(child.name == "child")
        #expect(grandchild.name == "grandchild")
    }
    
    @Test func name_rootNamespace() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(filePath: "root"),
                type: .group,
                providesNamespace: true))
        let child = ContentTree(
            Content(
                url: URL(filePath: "child"),
                type: .group,
                providesNamespace: false))
        let grandchild = ContentTree(
            Content(
                url: URL(filePath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        #expect(root.name == "root")
        #expect(child.name == "root/child")
        #expect(grandchild.name == "root/grandchild")
    }
    
    @Test func name_childNamespace() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(filePath: "root"),
                type: .group,
                providesNamespace: false))
        let child = ContentTree(
            Content(
                url: URL(filePath: "child"),
                type: .group,
                providesNamespace: true))
        let grandchild = ContentTree(
            Content(
                url: URL(filePath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        #expect(root.name == "root")
        #expect(child.name == "child")
        #expect(grandchild.name == "child/grandchild")
    }
    
    @Test func name_rootAndChildNamespace() {
        // Given
        let root = ContentTree(
            Content(
                url: URL(filePath: "root"),
                type: .group,
                providesNamespace: true))
        let child = ContentTree(
            Content(
                url: URL(filePath: "child"),
                type: .group,
                providesNamespace: true))
        let grandchild = ContentTree(
            Content(
                url: URL(filePath: "grandchild.imageset"),
                type: .asset(.imageSet),
                providesNamespace: false))
        
        root.addChild(child)
        child.addChild(grandchild)
        
        // Then
        #expect(root.name == "root")
        #expect(child.name == "root/child")
        #expect(grandchild.name == "root/child/grandchild")
    }
    
    @Test func filter() async throws {
        let tree: ContentTree = try ContentTree(Content(url: URL(filePath: "root")), children: [
            ContentTree(Content(url: URL(filePath: "root/child")), children: [
                ContentTree(Content(
                    url: URL(filePath: "root/child/grandchild1.imageset"),
                    type: .asset(.imageSet),
                    providesNamespace: false)),
                ContentTree(Content(
                    url: URL(filePath: "root/child/grandchild2.colorset"),
                    type: .asset(.colorSet),
                    providesNamespace: false)),
                ContentTree(Content(
                    url: URL(filePath: "root/child/grandchild3.imageset"),
                    type: .asset(.imageSet),
                    providesNamespace: false)),
            ])
        ])
        
        let filtered = try #require(tree.filter(matching: [.colorSet]))
        
        
        #expect(filtered.element.url == URL(filePath: "root"))
        
        #expect(filtered.children.count == 1)
        let child = try #require(filtered.children.first)
        #expect(child.element.url == URL(filePath: "root/child"))
        
        #expect(child.children.count == 1)
        let grandChild = try #require(child.children.first)
        #expect(grandChild.element.url == URL(filePath: "root/child/grandchild2.colorset"))
    }
}
