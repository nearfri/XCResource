import XCTest
@testable import FileKeyGen

final class FileTreeTests: XCTestCase {
    func test_relativePath() throws {
        let childTree = FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.tiff")))
        let parentTree = FileTree(FileItem(url: URL(filePath: "/root/tmp")), children: [childTree])
        let rootTree = FileTree(FileItem(url: URL(filePath: "/root")), children: [parentTree])
        
        XCTAssertEqual(childTree.relativePath, "tmp/scratch.tiff")
        
        withExtendedLifetime(rootTree, {})
    }
    
    func test_filenameToNamespace() throws {
        let childTree = FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.tiff")))
        let parentTree = FileTree(FileItem(url: URL(filePath: "/root/tmp")), children: [childTree])
        
        XCTAssertEqual(parentTree.filenameToNamespace(), "Tmp")
    }
    
    func test_filenameToKey() throws {
        let childTree = FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.tiff")))
        
        XCTAssertEqual(childTree.filenameToKey(), "scratch")
    }
    
    func test_filter_matchGrandChild_returnClone() throws {
        let childTree = FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.tiff")))
        let parentTree = FileTree(FileItem(url: URL(filePath: "/root/tmp")), children: [childTree])
        let rootTree = FileTree(FileItem(url: URL(filePath: "/root")), children: [parentTree])
        
        let tiff = try Regex("\\.tiff$")
        
        let filteredTree = try XCTUnwrap(rootTree.filter(tiff))
        
        XCTAssertEqual(filteredTree.url, URL(filePath: "/root"))
        
        XCTAssertEqual(filteredTree.children.first?.url,  URL(filePath: "/root/tmp"))
        
        XCTAssertEqual(filteredTree.children.first?.children.first?.url,
                       URL(filePath: "/root/tmp/scratch.tiff"))
    }
    
    func test_filter_matchChild_grandChildIsNil() throws {
        let childTree = FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.tiff")))
        let parentTree = FileTree(FileItem(url: URL(filePath: "/root/tmp")), children: [childTree])
        let rootTree = FileTree(FileItem(url: URL(filePath: "/root")), children: [parentTree])
        
        let tmp = try Regex("tmp$")
        
        let filteredTree = try XCTUnwrap(rootTree.filter(tmp))
        
        XCTAssertEqual(filteredTree.url, URL(filePath: "/root"))
        
        XCTAssertEqual(filteredTree.children.first?.url,  URL(filePath: "/root/tmp"))
        
        XCTAssertEqual(filteredTree.children.first?.children.isEmpty, true)
    }
    
    func test_filter_noMatch_returnNil() throws {
        let childTree = FileTree(FileItem(url: URL(filePath: "/root/tmp/scratch.tiff")))
        let parentTree = FileTree(FileItem(url: URL(filePath: "/root/tmp")), children: [childTree])
        let rootTree = FileTree(FileItem(url: URL(filePath: "/root")), children: [parentTree])
        
        let jpg = try Regex("\\.jpg$")
        
        let filteredTree = rootTree.filter(jpg)
        
        XCTAssertNil(filteredTree)
    }
}
