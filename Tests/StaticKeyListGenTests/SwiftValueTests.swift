import XCTest
@testable import StaticKeyListGen

private typealias Accessibility = SwiftValue.Accessibility

final class SwiftValueAccessibilityTests: XCTestCase {
    func test_lessThan() {
        XCTAssertLessThan(Accessibility.private, Accessibility.fileprivate)
        XCTAssertLessThan(Accessibility.fileprivate, Accessibility.internal)
        XCTAssertLessThan(Accessibility.internal, Accessibility.public)
        XCTAssertLessThan(Accessibility.public, Accessibility.open)
    }
    
    func test_greaterThan() {
        XCTAssertGreaterThan(Accessibility.open, Accessibility.public)
        XCTAssertGreaterThan(Accessibility.public, Accessibility.internal)
        XCTAssertGreaterThan(Accessibility.internal, Accessibility.fileprivate)
        XCTAssertGreaterThan(Accessibility.fileprivate, Accessibility.private)
    }
}
