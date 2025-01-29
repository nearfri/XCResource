import Testing
import TestUtil
@testable import FontResourceGen

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

@Suite struct DefaultValueDeclarationGeneratorTests {
    private let sut: DefaultValueDeclarationGenerator = .init()
    
    @Test func generateValueListDeclaration() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateValueListDeclaration(
            for: ValueDeclarationRequest(
                fonts: fonts,
                resourceTypeName: "FontResource",
                resourceListName: "all",
                transformsToLatin: false,
                stripsCombiningMarks: false,
                preservesRelativePath: true,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontResource {
                static let all: [FontResource] = [
                    // Avenir
                    .avenirHeavy,
                    .avenirLight,
                    
                    // Zapf Dingbats
                    .zapfDingbatsRegular,
                ]
            }
            """)
    }
    
    @Test func generateValueListDeclaration_latin_false() throws {
        // Given
        let fonts: [Font] = Fixture.hangulFonts
        
        // When
        let code = sut.generateValueListDeclaration(
            for: ValueDeclarationRequest(
                fonts: fonts,
                resourceTypeName: "FontResource",
                resourceListName: "all",
                transformsToLatin: false,
                stripsCombiningMarks: false,
                preservesRelativePath: true,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontResource {
                static let all: [FontResource] = [
                    // 대한
                    .대한Light,
                ]
            }
            """)
    }
    
    @Test func generateValueListDeclaration_latin_true() throws {
        // Given
        let fonts: [Font] = Fixture.hangulFonts
        
        // When
        let code = sut.generateValueListDeclaration(
            for: ValueDeclarationRequest(
                fonts: fonts,
                resourceTypeName: "FontResource",
                resourceListName: "all",
                transformsToLatin: true,
                stripsCombiningMarks: false,
                preservesRelativePath: true,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontResource {
                static let all: [FontResource] = [
                    // 대한
                    .daehanLight,
                ]
            }
            """)
    }
    
    @Test func generateValueDeclarations_latin_false() throws {
        // Given
        let fonts: [Font] = Fixture.hangulFonts
        
        // When
        let code = sut.generateValueDeclarations(
            for: ValueDeclarationRequest(
                fonts: fonts,
                resourceTypeName: "FontResource",
                transformsToLatin: false,
                stripsCombiningMarks: false,
                preservesRelativePath: false,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontResource {
                // MARK: 대한
                
                static let 대한Light: FontResource = .init(
                    fontName: "대한-Light",
                    familyName: "대한",
                    style: "light",
                    relativePath: "대한.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
    
    @Test func generateValueDeclarations_latin_true() throws {
        // Given
        let fonts: [Font] = Fixture.hangulFonts
        
        // When
        let code = sut.generateValueDeclarations(
            for: ValueDeclarationRequest(
                fonts: fonts,
                resourceTypeName: "FontResource",
                transformsToLatin: true,
                stripsCombiningMarks: false,
                preservesRelativePath: false,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontResource {
                // MARK: 대한
                
                static let daehanLight: FontResource = .init(
                    fontName: "대한-Light",
                    familyName: "대한",
                    style: "light",
                    relativePath: "대한.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
    
    @Test func generateValueDeclarations_preservesRelativePath_true() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateValueDeclarations(
            for: ValueDeclarationRequest(
                fonts: fonts,
                resourceTypeName: "FontResource",
                transformsToLatin: false,
                stripsCombiningMarks: false,
                preservesRelativePath: true,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontResource {
                // MARK: Avenir
                
                static let avenirHeavy: FontResource = .init(
                    fontName: "Avenir-Heavy",
                    familyName: "Avenir",
                    style: "heavy",
                    relativePath: "Fonts/Avenir.ttc",
                    bundle: Bundle.main)
                
                static let avenirLight: FontResource = .init(
                    fontName: "Avenir-Light",
                    familyName: "Avenir",
                    style: "light",
                    relativePath: "Fonts/Avenir.ttc",
                    bundle: Bundle.main)
                
                // MARK: Zapf Dingbats
                
                static let zapfDingbatsRegular: FontResource = .init(
                    fontName: "ZapfDingbatsITC",
                    familyName: "Zapf Dingbats",
                    style: "regular",
                    relativePath: "Fonts/Zapf.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
    
    @Test func generateValueDeclarations_preservesRelativePath_false() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateValueDeclarations(
            for: ValueDeclarationRequest(
                fonts: fonts,
                resourceTypeName: "FontResource",
                transformsToLatin: false,
                stripsCombiningMarks: false,
                preservesRelativePath: false,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontResource {
                // MARK: Avenir
                
                static let avenirHeavy: FontResource = .init(
                    fontName: "Avenir-Heavy",
                    familyName: "Avenir",
                    style: "heavy",
                    relativePath: "Avenir.ttc",
                    bundle: Bundle.main)
                
                static let avenirLight: FontResource = .init(
                    fontName: "Avenir-Light",
                    familyName: "Avenir",
                    style: "light",
                    relativePath: "Avenir.ttc",
                    bundle: Bundle.main)
                
                // MARK: Zapf Dingbats
                
                static let zapfDingbatsRegular: FontResource = .init(
                    fontName: "ZapfDingbatsITC",
                    familyName: "Zapf Dingbats",
                    style: "regular",
                    relativePath: "Zapf.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
    
    @Test func generateValueDeclarations_relativePathPrefix() throws {
        // Given
        let fonts: [Font] = Fixture.fonts
        
        // When
        let code = sut.generateValueDeclarations(
            for: ValueDeclarationRequest(
                fonts: fonts,
                resourceTypeName: "FontResource",
                transformsToLatin: false,
                stripsCombiningMarks: false,
                preservesRelativePath: true,
                relativePathPrefix: "Resources",
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        // Then
        expectEqual(code, """
            public extension FontResource {
                // MARK: Avenir
                
                static let avenirHeavy: FontResource = .init(
                    fontName: "Avenir-Heavy",
                    familyName: "Avenir",
                    style: "heavy",
                    relativePath: "Resources/Fonts/Avenir.ttc",
                    bundle: Bundle.main)
                
                static let avenirLight: FontResource = .init(
                    fontName: "Avenir-Light",
                    familyName: "Avenir",
                    style: "light",
                    relativePath: "Resources/Fonts/Avenir.ttc",
                    bundle: Bundle.main)
                
                // MARK: Zapf Dingbats
                
                static let zapfDingbatsRegular: FontResource = .init(
                    fontName: "ZapfDingbatsITC",
                    familyName: "Zapf Dingbats",
                    style: "regular",
                    relativePath: "Resources/Fonts/Zapf.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
}
