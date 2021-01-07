import XCTest
@testable import XCResourceApp

class StringKeyTests: XCTestCase {
    private var bundle: Bundle!
    
    override func setUpWithError() throws {
        let bundleURL = Bundle.main.url(forResource: "ko", withExtension: "lproj")!
        bundle = Bundle(url: bundleURL)!
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
