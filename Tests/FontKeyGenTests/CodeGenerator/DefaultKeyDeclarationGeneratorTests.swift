import Testing
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
    
    static let hangulFonts: [Font] = [
        Font(fontName: "대한-Light",
             familyName: "대한",
             style: "light",
             relativePath: "Fonts/대한.ttf"),
    ]
}

@Suite struct DefaultKeyDeclarationGeneratorTests {
    private let sut: DefaultKeyDeclarationGenerator = .init()
    
    @Test func generateKeyListDeclaration() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateKeyListDeclaration(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                keyListName: "all",
                generatesLatinKey: false,
                stripsCombiningMarksFromKey: false,
                preservesRelativePath: true,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontKey {
                static let all: [FontKey] = [
                    // Avenir
                    .avenirHeavy,
                    .avenirLight,
                    
                    // Zapf Dingbats
                    .zapfDingbatsRegular,
                ]
            }
            """)
    }
    
    @Test func generateKeyListDeclaration_latinKey_false() throws {
        // Given
        let fonts: [Font] = Fixture.hangulFonts
        
        // When
        let code = sut.generateKeyListDeclaration(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                keyListName: "all",
                generatesLatinKey: false,
                stripsCombiningMarksFromKey: false,
                preservesRelativePath: true,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontKey {
                static let all: [FontKey] = [
                    // 대한
                    .대한Light,
                ]
            }
            """)
    }
    
    @Test func generateKeyListDeclaration_latinKey_true() throws {
        // Given
        let fonts: [Font] = Fixture.hangulFonts
        
        // When
        let code = sut.generateKeyListDeclaration(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                keyListName: "all",
                generatesLatinKey: true,
                stripsCombiningMarksFromKey: false,
                preservesRelativePath: true,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontKey {
                static let all: [FontKey] = [
                    // 대한
                    .daehanLight,
                ]
            }
            """)
    }
    
    @Test func generateKeyDeclarations_latinKey_false() throws {
        // Given
        let fonts: [Font] = Fixture.hangulFonts
        
        // When
        let code = sut.generateKeyDeclarations(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                generatesLatinKey: false,
                stripsCombiningMarksFromKey: false,
                preservesRelativePath: false,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontKey {
                // MARK: 대한
                
                static let 대한Light: FontKey = .init(
                    fontName: "대한-Light",
                    familyName: "대한",
                    style: "light",
                    relativePath: "대한.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
    
    @Test func generateKeyDeclarations_latinKey_true() throws {
        // Given
        let fonts: [Font] = Fixture.hangulFonts
        
        // When
        let code = sut.generateKeyDeclarations(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                generatesLatinKey: true,
                stripsCombiningMarksFromKey: false,
                preservesRelativePath: false,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontKey {
                // MARK: 대한
                
                static let daehanLight: FontKey = .init(
                    fontName: "대한-Light",
                    familyName: "대한",
                    style: "light",
                    relativePath: "대한.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
    
    @Test func generateKeyDeclarations_preservesRelativePath_true() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateKeyDeclarations(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                generatesLatinKey: false,
                stripsCombiningMarksFromKey: false,
                preservesRelativePath: true,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontKey {
                // MARK: Avenir
                
                static let avenirHeavy: FontKey = .init(
                    fontName: "Avenir-Heavy",
                    familyName: "Avenir",
                    style: "heavy",
                    relativePath: "Fonts/Avenir.ttc",
                    bundle: Bundle.main)
                
                static let avenirLight: FontKey = .init(
                    fontName: "Avenir-Light",
                    familyName: "Avenir",
                    style: "light",
                    relativePath: "Fonts/Avenir.ttc",
                    bundle: Bundle.main)
                
                // MARK: Zapf Dingbats
                
                static let zapfDingbatsRegular: FontKey = .init(
                    fontName: "ZapfDingbatsITC",
                    familyName: "Zapf Dingbats",
                    style: "regular",
                    relativePath: "Fonts/Zapf.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
    
    @Test func generateKeyDeclarations_preservesRelativePath_false() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateKeyDeclarations(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                generatesLatinKey: false,
                stripsCombiningMarksFromKey: false,
                preservesRelativePath: false,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontKey {
                // MARK: Avenir
                
                static let avenirHeavy: FontKey = .init(
                    fontName: "Avenir-Heavy",
                    familyName: "Avenir",
                    style: "heavy",
                    relativePath: "Avenir.ttc",
                    bundle: Bundle.main)
                
                static let avenirLight: FontKey = .init(
                    fontName: "Avenir-Light",
                    familyName: "Avenir",
                    style: "light",
                    relativePath: "Avenir.ttc",
                    bundle: Bundle.main)
                
                // MARK: Zapf Dingbats
                
                static let zapfDingbatsRegular: FontKey = .init(
                    fontName: "ZapfDingbatsITC",
                    familyName: "Zapf Dingbats",
                    style: "regular",
                    relativePath: "Zapf.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
    
    @Test func generateKeyDeclarations_relativePathPrefix() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateKeyDeclarations(
            for: KeyDeclarationRequest(
                fonts: fonts,
                keyTypeName: "FontKey",
                generatesLatinKey: false,
                stripsCombiningMarksFromKey: false,
                preservesRelativePath: true,
                relativePathPrefix: "Resources",
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontKey {
                // MARK: Avenir
                
                static let avenirHeavy: FontKey = .init(
                    fontName: "Avenir-Heavy",
                    familyName: "Avenir",
                    style: "heavy",
                    relativePath: "Resources/Fonts/Avenir.ttc",
                    bundle: Bundle.main)
                
                static let avenirLight: FontKey = .init(
                    fontName: "Avenir-Light",
                    familyName: "Avenir",
                    style: "light",
                    relativePath: "Resources/Fonts/Avenir.ttc",
                    bundle: Bundle.main)
                
                // MARK: Zapf Dingbats
                
                static let zapfDingbatsRegular: FontKey = .init(
                    fontName: "ZapfDingbatsITC",
                    familyName: "Zapf Dingbats",
                    style: "regular",
                    relativePath: "Resources/Fonts/Zapf.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
}
