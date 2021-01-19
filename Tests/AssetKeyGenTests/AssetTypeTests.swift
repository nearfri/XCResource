import XCTest
@testable import AssetKeyGen

final class AssetTypeTests: XCTestCase {
    func test_initWithPathExtension() {
        XCTAssertNotNil(AssetType(pathExtension: "imageset"))
        XCTAssertNotNil(AssetType(pathExtension: "colorset"))
        XCTAssertNotNil(AssetType(pathExtension: "symbolset"))
        
        XCTAssertNil(AssetType(pathExtension: "imageSet"))
        XCTAssertNil(AssetType(pathExtension: "images"))
        XCTAssertNil(AssetType(pathExtension: "image"))
    }
}
