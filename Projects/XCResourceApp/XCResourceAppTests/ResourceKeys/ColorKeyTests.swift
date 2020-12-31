import XCTest
@testable import XCResourceApp

class ColorKeyTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_colorsExist() throws {
        for key in ColorKey.allGeneratedKeys where key.rawValue != "AccentColor" {
            XCTAssertNotNil(UIColor(named: key.rawValue, in: .module, compatibleWith: nil),
                            "\(key.rawValue) color not found")
        }
    }
    
}
