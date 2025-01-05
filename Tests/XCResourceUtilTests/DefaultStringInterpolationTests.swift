import Testing
@testable import XCResourceUtil

private struct GroceryProduct: Codable {
    var name: String
    var points: Int
    var description: String?
}

private enum Fixture {
    static let productJSON = """
    {
      "name" : "Pear",
      "points" : 250
    }
    """
}

@Suite struct DefaultStringInterpolationTests {
    @Test func appendJSON() throws {
        // Given
        let product = GroceryProduct(name: "Pear", points: 250, description: nil)
        
        // When
        let json = try "\(json: product)"
        
        // Then
        #expect(json == Fixture.productJSON)
    }
}
