import XCTest
@testable import Resources

final class ColorKeyTests: XCTestCase {
    func test_colorsExist() throws {
        let keys: [ColorKey] = [
            .cobalt, .lightRose, .marigold
        ]
        
        for key in keys {
            XCTAssertNotNil(NativeColor(named: key.rawValue, in: .module),
                            "\(key.rawValue) color not found")
        }
    }
}
