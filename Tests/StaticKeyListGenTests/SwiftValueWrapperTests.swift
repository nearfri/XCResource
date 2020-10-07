import XCTest
@testable import StaticKeyListGen

private typealias Accessibility = SwiftValue.Accessibility

private struct SwiftModel {
    @SwiftValueWrapper<String, Accessibility>
    var accessibility: String? = nil
}

final class SwiftValueWrapperTests: XCTestCase {
    func test_projectedValue_validWrappedValue() {
        // Given
        let model = SwiftModel(accessibility: Accessibility.public.rawValue)
        
        // When
        let accessibility: Accessibility? = model.$accessibility
        
        // Then
        XCTAssertEqual(accessibility, .public)
    }
    
    func test_projectedValue_invalidWrappedValue() {
        // Given
        let model = SwiftModel(accessibility: "invalid accessibility value")
        
        // When
        let accessibility: Accessibility? = model.$accessibility
        
        // Then
        XCTAssertNil(accessibility)
    }
}
