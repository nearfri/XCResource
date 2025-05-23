import Testing
import Foundation
@testable import XCResourceUtil

@Suite struct FileManagerTests {
    @Test func makeTemporaryItemURL() {
        let fm = FileManager.default
        #expect(fm.makeTemporaryItemURL() != fm.makeTemporaryItemURL())
    }
    
    @Test func compareAndReplaceItem_notEqualFile_replaceItem() throws {
        // Given
        let fm = FileManager.default
        
        let oriData = Data(repeating: 1, count: 1)
        let newData = Data(repeating: 2, count: 1)
        
        let oriFileURL = fm.makeTemporaryItemURL()
        let newFileURL = fm.makeTemporaryItemURL()
        
        try oriData.write(to: oriFileURL)
        try newData.write(to: newFileURL)
        
        let attributes = try fm.attributesOfItem(atPath: oriFileURL.path)
        let creationDate = attributes[.creationDate] as! Date
        let modificationDate = attributes[.modificationDate] as! Date
        
        // When
        try fm.compareAndReplaceItem(at: oriFileURL, withItemAt: newFileURL)
        
        // Then
        let updatedAttributes = try fm.attributesOfItem(atPath: oriFileURL.path)
        
        #expect(!fm.fileExists(atPath: newFileURL.path))
        #expect(try Data(contentsOf: oriFileURL) == newData)
        #expect(updatedAttributes[.creationDate] as! Date == creationDate)
        #expect(updatedAttributes[.modificationDate] as! Date != modificationDate)
    }
    
    @Test func compareAndReplaceItem_equalFile_removeNewItemAndKeepOriginal() throws {
        // Given
        let fm = FileManager.default
        
        let oriData = Data(repeating: 1, count: 1)
        let newData = Data(repeating: 1, count: 1)
        
        let oriFileURL = fm.makeTemporaryItemURL()
        let newFileURL = fm.makeTemporaryItemURL()
        
        try oriData.write(to: oriFileURL)
        try newData.write(to: newFileURL)
        
        let attributes = try fm.attributesOfItem(atPath: oriFileURL.path)
        let creationDate = attributes[.creationDate] as! Date
        let modificationDate = attributes[.modificationDate] as! Date
        
        // When
        try fm.compareAndReplaceItem(at: oriFileURL, withItemAt: newFileURL)
        
        // Then
        let updatedAttributes = try fm.attributesOfItem(atPath: oriFileURL.path)
        
        #expect(!fm.fileExists(atPath: newFileURL.path))
        #expect(try Data(contentsOf: oriFileURL) == oriData)
        #expect(updatedAttributes[.creationDate] as! Date == creationDate)
        #expect(updatedAttributes[.modificationDate] as! Date == modificationDate)
    }
}
