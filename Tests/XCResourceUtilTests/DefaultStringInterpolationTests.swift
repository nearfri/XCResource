import XCTest
@testable import XCResourceUtil

private struct GroceryProduct: Codable {
    var name: String
    var points: Int
    var description: String?
}

private enum Seed {
    static let productJSON = """
    {
      "name" : "Pear",
      "points" : 250
    }
    """
}

final class DefaultStringInterpolationTests: XCTestCase {
    func test_appendJSON() throws {
        // Given
        let product = GroceryProduct(name: "Pear", points: 250, description: nil)
        
        // When
        let json = try "\(json: product)"
        
        // Then
        XCTAssertEqual(json, Seed.productJSON)
    }
}
