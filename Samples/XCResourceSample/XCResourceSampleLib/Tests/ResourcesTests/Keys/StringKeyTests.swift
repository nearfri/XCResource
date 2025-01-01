import XCTest
@testable import Resources

final class StringKeyTests: XCTestCase {
    private var bundle: Bundle!
    
    override func setUpWithError() throws {
        let bundleURL = Bundle.module.url(forResource: "ko", withExtension: "lproj")!
        bundle = Bundle(url: bundleURL)!
    }
    
    func test_localizedStringsExist() throws {
        let defaultString = "$_LOCALIZED_STRING_NOT_FOUND_$"
        
        for key in StringKey.allCases {
            let string = bundle.localizedString(forKey: key.rawValue,
                                                value: defaultString,
                                                table: nil)
            XCTAssert(string != defaultString, "\(key.rawValue) localized string not found")
        }
    }
}
