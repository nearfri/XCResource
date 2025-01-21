import Testing
import Foundation
@testable import Resources

struct FileResourceTests {
    @Test func filesExist() throws {
        let fileResources: [FileResource] = [
            .cambria,
            .OpenSans.openSansBold,
            .OpenSans.openSansRegular,
        ]
        
        let fm = FileManager.default
        
        for fileResource in fileResources {
            #expect(fm.fileExists(atPath: fileResource.path),
                    "File not found: \(fileResource.path)")
        }
    }
}
