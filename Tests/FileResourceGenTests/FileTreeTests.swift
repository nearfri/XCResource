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
    
    @Test func filenameToNamespace() throws {
        let childTree = FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.tiff")))
        let parentTree = FileTree(FileItem(url: URL(filePath: "/root/tmp")), children: [childTree])
        
        #expect(parentTree.filenameToNamespace() == "Tmp")
    }
    
    @Test func filenameToIdentifier() throws {
        let childTree = FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.tiff")))
        
        #expect(childTree.filenameToIdentifier() == "scratch")
    }
    
    @Test func filter_matchGrandChild_returnClone() throws {
        let childTree = FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.tiff")))
        let parentTree = FileTree(FileItem(url: URL(filePath: "/root/tmp")), children: [childTree])
        let rootTree = FileTree(FileItem(url: URL(filePath: "/root")), children: [parentTree])
        
        let tiff = try Regex("\\.tiff$")
        
        let filteredTree = try #require(rootTree.filter(tiff))
        
        #expect(filteredTree.url == URL(filePath: "/root"))
        
        #expect(filteredTree.children.first?.url == URL(filePath: "/root/tmp"))
        
        #expect(filteredTree.children.first?.children.first?.url ==
                URL(filePath: "/root/tmp/scratch.tiff"))
    }
    
    @Test func filter_matchChild_grandChildIsNil() throws {
        let childTree = FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.tiff")))
        let parentTree = FileTree(FileItem(url: URL(filePath: "/root/tmp")), children: [childTree])
        let rootTree = FileTree(FileItem(url: URL(filePath: "/root")), children: [parentTree])
        
        let tmp = try Regex("tmp$")
        
        let filteredTree = try #require(rootTree.filter(tmp))
        
        #expect(filteredTree.url == URL(filePath: "/root"))
        
        #expect(filteredTree.children.first?.url == URL(filePath: "/root/tmp"))
        
        #expect(filteredTree.children.first?.children.isEmpty == true)
    }
    
    @Test func filter_noMatch_returnNil() throws {
        let childTree = FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.tiff")))
        let parentTree = FileTree(FileItem(url: URL(filePath: "/root/tmp")), children: [childTree])
        let rootTree = FileTree(FileItem(url: URL(filePath: "/root")), children: [parentTree])
        
        let jpg = try Regex("\\.jpg$")
        
        let filteredTree = rootTree.filter(jpg)
        
        #expect(filteredTree == nil)
    }
}
