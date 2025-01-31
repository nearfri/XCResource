import Testing
import Foundation
@testable import FileResourceGen

@Suite struct FileItemTests {
    @Test func namespace() throws {
        let sut = FileItem(url: URL(filePath: "/root/tmp"))
        
        #expect(sut.namespace == "Tmp")
    }
    
    @Test func identifier() throws {
        let sut = FileItem(url: URL(filePath: "/root/tmp/scratch.tiff"))
        
        #expect(sut.identifier == "scratch")
    }
}
