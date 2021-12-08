import XCTest
@testable import XCResourceCommand
import SampleData

final class CSVToStringsTests: XCTestCase {
    func test_runAsRoot() throws {
        // Given
        let fm = FileManager.default
        
        let localizationURL = SampleData.localizationDirectoryURL()
        let resourcesURL = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.copyItem(at: localizationURL, to: resourcesURL)
        
        let csvFileURL = resourcesURL.appendingPathComponent("localizations.csv")
        
        defer {
            try? fm.removeItem(at: resourcesURL)
        }
        
        // When
        try CSVToStrings.runAsRoot(arguments: [
            "--csv-path", csvFileURL.path,
            "--header-style", "short",
            "--resources-path", resourcesURL.path,
            "--table-name", "Translated",
        ])
        
        // Then
        let actualEnURL = resourcesURL.appendingPathComponent("en.lproj/Translated.strings")
        let actualKoURL = resourcesURL.appendingPathComponent("ko.lproj/Translated.strings")
        
        let expectedEnURL = resourcesURL.appendingPathComponent("en.lproj/Localizable.strings")
        let expectedKoURL = resourcesURL.appendingPathComponent("ko.lproj/Localizable.strings")
        
        XCTAssertEqual(try String(contentsOf: actualEnURL), try String(contentsOf: expectedEnURL))
        XCTAssertEqual(try String(contentsOf: actualKoURL), try String(contentsOf: expectedKoURL))
    }
}
