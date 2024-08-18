import XCTest
import TestUtil
@testable import FontKeyGen

private enum Fixture {
    static let fonts: [Font] = [
        Font(fontName: "Avenir-Heavy",
             familyName: "Avenir",
             style: "heavy",
             relativePath: "Fonts/Avenir.ttc"),
        Font(fontName: "Avenir-Light",
             familyName: "Avenir",
             style: "light",
             relativePath: "Fonts/Avenir.ttc"),
        Font(fontName: "ZapfDingbatsITC",
             familyName: "Zapf Dingbats",
             style: "regular",
             relativePath: "Fonts/Zapf.ttf"),
    ]
}

final class DefaultKeyDeclarationGeneratorTests: XCTestCase {
    private let sut: DefaultKeyDeclarationGenerator = .init()
    
    func test_generateKeyListDeclaration() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateKeyListDeclaration(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                keyListName: "all",
                preservesRelativePath: true,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
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
    
    func test_generateKeyDeclarations_preservesRelativePath_true() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateKeyDeclarations(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                preservesRelativePath: true,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        XCTAssertEqual(code, """
            public extension FontKey {
                // MARK: Avenir
                
                static let avenir_heavy: FontKey = .init(
                    fontName: "Avenir-Heavy",
                    familyName: "Avenir",
                    style: "heavy",
                    relativePath: "Fonts/Avenir.ttc",
                    bundle: Bundle.main)
                
                static let avenir_light: FontKey = .init(
                    fontName: "Avenir-Light",
                    familyName: "Avenir",
                    style: "light",
                    relativePath: "Fonts/Avenir.ttc",
                    bundle: Bundle.main)
                
                // MARK: Zapf Dingbats
                
                static let zapfDingbats_regular: FontKey = .init(
                    fontName: "ZapfDingbatsITC",
                    familyName: "Zapf Dingbats",
                    style: "regular",
                    relativePath: "Fonts/Zapf.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
    
    func test_generateKeyDeclarations_preservesRelativePath_false() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateKeyDeclarations(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                preservesRelativePath: false,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        XCTAssertEqual(code, """
            public extension FontKey {
                // MARK: Avenir
                
                static let avenir_heavy: FontKey = .init(
                    fontName: "Avenir-Heavy",
                    familyName: "Avenir",
                    style: "heavy",
                    relativePath: "Avenir.ttc",
                    bundle: Bundle.main)
                
                static let avenir_light: FontKey = .init(
                    fontName: "Avenir-Light",
                    familyName: "Avenir",
                    style: "light",
                    relativePath: "Avenir.ttc",
                    bundle: Bundle.main)
                
                // MARK: Zapf Dingbats
                
                static let zapfDingbats_regular: FontKey = .init(
                    fontName: "ZapfDingbatsITC",
                    familyName: "Zapf Dingbats",
                    style: "regular",
                    relativePath: "Zapf.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
    
    func test_generateKeyDeclarations_relativePathPrefix() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateKeyDeclarations(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                preservesRelativePath: true,
                relativePathPrefix: "Resources",
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        XCTAssertEqual(code, """
            public extension FontKey {
                // MARK: Avenir
                
                static let avenir_heavy: FontKey = .init(
                    fontName: "Avenir-Heavy",
                    familyName: "Avenir",
                    style: "heavy",
                    relativePath: "Resources/Fonts/Avenir.ttc",
                    bundle: Bundle.main)
                
                static let avenir_light: FontKey = .init(
                    fontName: "Avenir-Light",
                    familyName: "Avenir",
                    style: "light",
                    relativePath: "Resources/Fonts/Avenir.ttc",
                    bundle: Bundle.main)
                
                // MARK: Zapf Dingbats
                
                static let zapfDingbats_regular: FontKey = .init(
                    fontName: "ZapfDingbatsITC",
                    familyName: "Zapf Dingbats",
                    style: "regular",
                    relativePath: "Resources/Fonts/Zapf.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
}
