import XCTest
@testable import Util

final class FileManagerTests: XCTestCase {
    func test_makeTemporaryFileURL() {
        let fm = FileManager.default
        XCTAssertNotEqual(fm.makeTemporaryFileURL(), fm.makeTemporaryFileURL())
    }
    
    func test_compareAndMoveFile_notEqualFile_move() throws {
        // Given
        let fm = FileManager.default
        
        let data1 = Data(repeating: 1, count: 1)
        let data2 = Data(repeating: 2, count: 1)
        
        let url1 = fm.makeTemporaryFileURL()
        let url2 = fm.makeTemporaryFileURL()
        
        try data1.write(to: url1)
        try data2.write(to: url2)
        
        let date2 = (try fm.attributesOfItem(atPath: url2.path))[.creationDate] as! Date
        
        // When
        try fm.compareAndMoveFile(from: url1, to: url2)
        
        // Then
        XCTAssertEqual(try Data(contentsOf: url2), data1)
        let newDate2 = (try fm.attributesOfItem(atPath: url2.path))[.creationDate] as! Date
        XCTAssertNotEqual(newDate2, date2)
    }
    
    func test_compareAndMoveFile_equalFile_notMove() throws {
        // Given
        let fm = FileManager.default
        
        let data1 = Data(repeating: 1, count: 1)
        let data2 = Data(repeating: 1, count: 1)
        
        let url1 = fm.makeTemporaryFileURL()
        let url2 = fm.makeTemporaryFileURL()
        
        try data1.write(to: url1)
        try data2.write(to: url2)
        
        let date2 = (try fm.attributesOfItem(atPath: url2.path))[.creationDate] as! Date
        
        // When
        try fm.compareAndMoveFile(from: url1, to: url2)
        
        // Then
        XCTAssertEqual(try Data(contentsOf: url2), data1)
        let newDate2 = (try fm.attributesOfItem(atPath: url2.path))[.creationDate] as! Date
        XCTAssertEqual(newDate2, date2)
    }
}
