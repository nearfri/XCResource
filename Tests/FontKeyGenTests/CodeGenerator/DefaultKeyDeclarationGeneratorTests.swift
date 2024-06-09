import XCTest
import TestUtil
@testable import FontKeyGen

private enum Fixture {
    static let fonts: [Font] = [
        Font(fontName: "Avenir-Heavy",
             familyName: "Avenir",
             style: "heavy",
             path: "Avenir.ttc"),
        Font(fontName: "Avenir-Light",
             familyName: "Avenir",
             style: "light",
             path: "Avenir.ttc"),
        Font(fontName: "ZapfDingbatsITC",
             familyName: "Zapf Dingbats",
             style: "regular",
             path: "Zapf.ttf"),
    ]
}

final class DefaultKeyDeclarationGeneratorTests: XCTestCase {
    private let sut: DefaultKeyDeclarationGenerator = .init()
    
    func test_generateAllKeysDeclaration() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateAllKeysDeclaration(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                accessLevel: "public"))
        
        // Then
        XCTAssertEqual(code, """
            public extension FontKey {
                static let all: [FontKey] = [
                    // Avenir
                    .avenir_heavy,
                    .avenir_light,
                    
                    // Zapf Dingbats
                    .zapfDingbats_regular,
                ]
            }
            """)
    }
    
    func test_generateKeyDeclarations() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateKeyDeclarations(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                accessLevel: "public"))
        
        // Then
        XCTAssertEqual(code, """
            public extension FontKey {
                // MARK: Avenir
                
                static let avenir_heavy: FontKey = .init(
                    fontName: "Avenir-Heavy",
                    familyName: "Avenir",
                    style: "heavy",
                    path: "Avenir.ttc")
                
                static let avenir_light: FontKey = .init(
                    fontName: "Avenir-Light",
                    familyName: "Avenir",
                    style: "light",
                    path: "Avenir.ttc")
                
                // MARK: Zapf Dingbats
                
                static let zapfDingbats_regular: FontKey = .init(
                    fontName: "ZapfDingbatsITC",
                    familyName: "Zapf Dingbats",
                    style: "regular",
                    path: "Zapf.ttf")
            }
            """)
    }
}
