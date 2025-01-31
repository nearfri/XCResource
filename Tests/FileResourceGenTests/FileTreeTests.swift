import Testing
import Foundation
@testable import FileResourceGen

@Suite struct FileTreeTests {
    @Test func relativePath() throws {
        let childTree = FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.tiff")))
        let parentTree = FileTree(FileItem(url: URL(filePath: "/root/tmp")), children: [childTree])
        let rootTree = FileTree(FileItem(url: URL(filePath: "/root")), children: [parentTree])
        
        #expect(childTree.relativePath == "tmp/scratch.tiff")
        
        withExtendedLifetime(rootTree, {})
    }
    
    @Test func filter() throws {
        let tree: FileTree = FileTree(FileItem(url: URL(filePath: "/root")), children: [
            FileTree(FileItem(url: URL(filePath: "/root/tmp")), children: [
                FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.png"))),
                FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.tiff"))),
            ])
        ])
        
        let tiff = try Regex("\\.tiff$")
        
        let filtered = try #require(tree.filter(tiff))
        
        #expect(filtered.url == URL(filePath: "/root"))
        
        #expect(filtered.children.count == 1)
        let child = try #require(filtered.children.first)
        #expect(child.url == URL(filePath: "/root/tmp"))
        
        #expect(child.children.count == 1)
        let grandChild = try #require(child.children.first)
        #expect(grandChild.url == URL(filePath: "/root/tmp/scratch.tiff"))
    }
}
