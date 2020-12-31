import XCTest
@testable import XCResourceUtil

final class FileManagerTests: XCTestCase {
    func test_makeTemporaryItemURL() {
        let fm = FileManager.default
        XCTAssertNotEqual(fm.makeTemporaryItemURL(), fm.makeTemporaryItemURL())
    }
    
    func test_compareAndReplaceItem_notEqualFile_replaceItem() throws {
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
        
        XCTAssertFalse(fm.fileExists(atPath: newFileURL.path))
        XCTAssertEqual(try Data(contentsOf: oriFileURL), newData)
        XCTAssertEqual(updatedAttributes[.creationDate] as! Date, creationDate)
        XCTAssertNotEqual(updatedAttributes[.modificationDate] as! Date, modificationDate)
    }
    
    func test_compareAndReplaceItem_equalFile_removeNewItemAndKeepOriginal() throws {
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
        
        XCTAssertFalse(fm.fileExists(atPath: newFileURL.path))
        XCTAssertEqual(try Data(contentsOf: oriFileURL), oriData)
        XCTAssertEqual(updatedAttributes[.creationDate] as! Date, creationDate)
        XCTAssertEqual(updatedAttributes[.modificationDate] as! Date, modificationDate)
    }
}
