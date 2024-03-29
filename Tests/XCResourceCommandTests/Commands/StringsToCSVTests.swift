import XCTest
import TestUtil
import SampleData
@testable import XCResourceCommand

final class StringsToCSVTests: XCTestCase {
    func test_runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let resourcesURL = SampleData.localizationDirectoryURL()
        let urlOfActualCSVFile = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let urlOfExpectedCSVFile = resourcesURL.appendingPathComponent("localizations.csv")
        
        defer {
            try? fm.removeItem(at: urlOfActualCSVFile)
        }
        
        // When
        try StringsToCSV.runAsRoot(arguments: [
            "--resources-path", resourcesURL.path,
            "--development-language", "ko",
            "--csv-path", urlOfActualCSVFile.path,
            "--header-style", "short",
        ])
        
        // Then
        XCTAssertEqual(try String(contentsOf: urlOfActualCSVFile),
                       try String(contentsOf: urlOfExpectedCSVFile))
    }
}
