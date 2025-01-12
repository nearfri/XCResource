import XCTest
@testable import Resources

final class FileResourceTests: XCTestCase {
    func test_filesExist() throws {
        let fileResources: [FileResource] = [
            .cambria,
            .OpenSans.openSansBold,
            .OpenSans.openSansRegular,
        ]
        
        let fm = FileManager.default
        
        for fileResource in fileResources {
            XCTAssert(fm.fileExists(atPath: fileResource.path),
                      "File not found: \(fileResource.path)")
        }
    }
}
