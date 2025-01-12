import XCTest
@testable import Resources

final class ResourceTests: XCTestCase {
    func test_imagesExist() throws {
        let keys: [ImageKey] = [
            .textFormattingLink, .textFormattingBold,
            .places_authArrow, .places_dot_medium
        ]
        
        for key in keys {
            XCTAssertNotNil(NativeImage(named: key.rawValue, in: .module),
                            "\(key.rawValue) image not found")
        }
    }
}
