import XCTest
@testable import XCResourceApp

class ImageKeyTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_imagesExist() throws {
        let keys: [ImageKey] = [
            .settings, .settingsFAQ, .textFormattingLink, .textFormattingBold,
            .places_authArrow, .places_filterSaved, .places_dot_medium, .places_dot_outlineMedium
        ]
        
        for key in keys {
            XCTAssertNotNil(UIImage(named: key.rawValue, in: .module, compatibleWith: nil),
                            "\(key.rawValue) image not found")
        }
    }
    
}
