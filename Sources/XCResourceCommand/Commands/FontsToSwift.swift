import Foundation
import ArgumentParser
import FontResourceGen
import XCResourceUtil

private let headerComment = """
// This file was generated by xcresource.
// Do Not Edit Directly!
"""

struct FontsToSwift: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "fonts2swift",
        abstract: "Generate Swift code for accessing fonts.",
        discussion: """
            This command generates Swift code to access fonts in a type-safe manner. \
            It scans the specified directory for font files and \
            generates code to access these fonts.
            """)
    
    // MARK: - Default values
    
    enum Default {
        static let bundle: String = "Bundle.main"
        static let transformsToLatin: Bool = false
        static let stripsCombiningMarks: Bool = false
        static let preservesRelativePath: Bool = true
        static let excludesTypeDeclaration: Bool = false
    }
    
    // MARK: - Arguments
    
    @Option var resourcesPath: String
    
    @Option var swiftFilePath: String
    
    @Option var resourceTypeName: String
    
    @Option var resourceListName: String?
    
    @Flag(name: .customLong("transform-to-latin"))
    var transformsToLatin: Bool = Default.transformsToLatin
    
    @Flag(name: .customLong("strip-combining-marks"))
    var stripsCombiningMarks: Bool = Default.stripsCombiningMarks
    
    @Flag(name: .customLong("preserve-relative-path"), inversion: .prefixedNo)
    var preservesRelativePath: Bool = Default.preservesRelativePath
    
    @Option var relativePathPrefix: String?
    
    @Option var bundle: String = Default.bundle
    
    @Option(help: ArgumentHelp(valueName: AccessLevel.joinedAllValuesString))
    var accessLevel: AccessLevel?
    
    @Flag(name: .customLong("exclude-type-declaration"))
    var excludesTypeDeclaration: Bool = Default.excludesTypeDeclaration
    
    // MARK: - Run
    
    mutating func run() throws {
        let codes = try generateCodes()
        
        try writeCodes(codes)
    }
    
    private func generateCodes() throws -> FontResourceGenerator.Result {
        let request = FontResourceGenerator.Request(
            resourcesURL: URL(filePath: resourcesPath, expandingTilde: true),
            resourceTypeName: resourceTypeName,
            resourceListName: resourceListName,
            transformsToLatin: transformsToLatin,
            stripsCombiningMarks: stripsCombiningMarks,
            preservesRelativePath: preservesRelativePath,
            relativePathPrefix: relativePathPrefix,
            bundle: bundle,
            accessLevel: accessLevel?.rawValue)
        
        return try FontResourceGenerator().generate(for: request)
    }
    
    private func writeCodes(_ codes: FontResourceGenerator.Result) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        var stream = try TextFileOutputStream(forWritingTo: tempFileURL)
        
        print(headerComment, terminator: "\n\n", to: &stream)
        
        print("import Foundation", terminator: "\n\n", to: &stream)
        
        if !excludesTypeDeclaration {
            print(codes.typeDeclaration, terminator: "\n\n", to: &stream)
        }
        
        if let valueListDeclaration = codes.valueListDeclaration {
            print(valueListDeclaration, terminator: "\n\n", to: &stream)
        }
        
        print(codes.valueDeclarations, to: &stream)
        
        try stream.close()
        try FileManager.default.compareAndReplaceItem(at: swiftFilePath, withItemAt: tempFileURL)
    }
}
