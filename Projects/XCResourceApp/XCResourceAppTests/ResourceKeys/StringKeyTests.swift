import XCTest
@testable import XCResourceApp

class StringKeyTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_localizedStringsExist() throws {
        let defaultString = "$_LOCALIZED_STRING_NOT_FOUND_$"
        
        for key in StringKey.allCases {
            let string = NSLocalizedString(key.rawValue,
                                           bundle: .module,
                                           value: defaultString,
                                           comment: "")
            XCTAssert(string != defaultString, "\(key.rawValue) localized string not found")
        }
    }
    
}
