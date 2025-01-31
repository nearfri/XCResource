import Testing
import Foundation
import TestUtil
@testable import FileResourceGen

private enum Fixture {
    static func fileTree() -> FileTree {
        let sfnsBold = FileTree(
            FileItem(url: URL(filePath: "/Fonts/SFNSDisplay/SFNSDisplay-Bold.ttf")))
        
        let sfnsRegular = FileTree(
            FileItem(url: URL(filePath: "/Fonts/SFNSDisplay/SFNSDisplay-Regular.ttf")))
        
        let sfns = FileTree(
            FileItem(url: URL(filePath: "/Fonts/SFNSDisplay")), children: [sfnsBold, sfnsRegular])
        
        let avenir = FileTree(
            FileItem(url: URL(filePath: "/Fonts/Avenir.ttf")))
        
        let fonts = FileTree(FileItem(url: URL(filePath: "/Fonts")), children: [sfns, avenir])
        
        return fonts
    }
}

@Suite struct DefaultValueDeclarationGeneratorTests {
    private let sut: DefaultValueDeclarationGenerator = .init()
    
    @Test func generateValueDeclarations_preservesRelativePath_true() throws {
        let code = sut.generate(
            for: ValueDeclarationRequest(
                fileTree: Fixture.fileTree(),
                resourceTypeName: "FileResource",
                preservesRelativePath: true,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        expectEqual(code, """
            extension FileResource {
                public enum SFNSDisplay {
                    public static let sfnsDisplayBold: FileResource = .init(
                        relativePath: "SFNSDisplay/SFNSDisplay-Bold.ttf",
                        bundle: Bundle.main)
                    
                    public static let sfnsDisplayRegular: FileResource = .init(
                        relativePath: "SFNSDisplay/SFNSDisplay-Regular.ttf",
                        bundle: Bundle.main)
                }
                
                public static let avenir: FileResource = .init(
                    relativePath: "Avenir.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
    
    @Test func generateValueDeclarations_preservesRelativePath_false() throws {
        let code = sut.generate(
            for: ValueDeclarationRequest(
                fileTree: Fixture.fileTree(),
                resourceTypeName: "FileResource",
                preservesRelativePath: false,
                relativePathPrefix: nil,
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        expectEqual(code, """
            extension FileResource {
                public static let sfnsDisplayBold: FileResource = .init(
                    relativePath: "SFNSDisplay-Bold.ttf",
                    bundle: Bundle.main)
                
                public static let sfnsDisplayRegular: FileResource = .init(
                    relativePath: "SFNSDisplay-Regular.ttf",
                    bundle: Bundle.main)
                
                public static let avenir: FileResource = .init(
                    relativePath: "Avenir.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
    
    @Test func generateValueDeclarations_relativePathPrefix() throws {
        let code = sut.generate(
            for: ValueDeclarationRequest(
                fileTree: Fixture.fileTree(),
                resourceTypeName: "FileResource",
                preservesRelativePath: true,
                relativePathPrefix: "Fonts",
                bundle: "Bundle.main",
                accessLevel: "public"))
        
        expectEqual(code, """
            extension FileResource {
                public enum SFNSDisplay {
                    public static let sfnsDisplayBold: FileResource = .init(
                        relativePath: "Fonts/SFNSDisplay/SFNSDisplay-Bold.ttf",
                        bundle: Bundle.main)
                    
                    public static let sfnsDisplayRegular: FileResource = .init(
                        relativePath: "Fonts/SFNSDisplay/SFNSDisplay-Regular.ttf",
                        bundle: Bundle.main)
                }
                
                public static let avenir: FileResource = .init(
                    relativePath: "Fonts/Avenir.ttf",
                    bundle: Bundle.main)
            }
            """)
    }
}
