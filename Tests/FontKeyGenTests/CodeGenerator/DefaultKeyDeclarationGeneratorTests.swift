import XCTest
import TestUtil
@testable import FontKeyGen

final class DefaultKeyDeclarationGeneratorTests: XCTestCase {
    private let sut: DefaultKeyDeclarationGenerator = .init()
    
    func test_generate_oneFont() throws {
        // Given
        let fonts: [Font] = [
            Font(fontName: "ZapfDingbatsITC",
                 familyName: "Zapf Dingbats",
                 style: "regular",
                 path: "Zapf.ttf")
        ]
        
        // When
        let code = sut.generate(fonts: fonts, keyTypeName: "FontKey", accessLevel: "public")
        
        // Then
        XCTAssertEqual(code, """
            public extension FontKey {
                // MARK: Zapf Dingbats
                
                static let zapfDingbats_regular: FontKey = .init(
                    fontName: "ZapfDingbatsITC",
                    familyName: "Zapf Dingbats",
                    style: "regular",
                    path: "Zapf.ttf")
            }
            """)
    }
    
    func test_generate_manyFonts() throws {
        // Given
        let fonts: [Font] = [
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
        
        // When
        let code = sut.generate(fonts: fonts, keyTypeName: "FontKey", accessLevel: "public")
        
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
