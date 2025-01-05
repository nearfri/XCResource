import Testing
import Foundation
import TestUtil
import SampleData
@testable import XCResourceCommand

@Suite struct StringsToCSVTests {
    @Test func runAsRoot() throws {
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
        expectEqual(try String(contentsOf: urlOfActualCSVFile, encoding: .utf8),
                    try String(contentsOf: urlOfExpectedCSVFile, encoding: .utf8))
    }
}
