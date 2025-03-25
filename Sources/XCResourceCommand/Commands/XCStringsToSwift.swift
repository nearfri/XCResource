import Foundation
import ArgumentParser
import XCResourceUtil
import LocStringResourceGen

struct XCStringsToSwift: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "xcstrings2swift",
        abstract: "Generate Swift code for accessing localized strings.",
        discussion: """
            This command generates Swift code to access localized strings in a type-safe manner. \
            It scans the specified .xcstrings file and \
            generates code to access these localized strings.
            """)
    
    // MARK: - Default Values
    
    enum Default {
        static let table: String = "Localizable"
        static let bundle: LocalizationItem.BundleDescription = .main
        static let resourceTypeName: String = "LocalizedStringResource"
    }
    
    // MARK: - Arguments
    
    @Option var catalogPath: String
    
    @Option(help: ArgumentHelp(valueName: LocalizationItem.BundleDescription.joinedAllValuesString))
    var bundle: LocalizationItem.BundleDescription = Default.bundle
    
    @Option var swiftFilePath: String
    
    @Option var resourceTypeName: String = Default.resourceTypeName
    
    // MARK: - Run
    
    mutating func run() throws {
        let code = try generateCode()
        
        try writeCode(code)
    }
    
    private func generateCode() throws -> String {
        let catalogFileURL = URL(filePath: catalogPath, expandingTilde: true)
        let swiftFileURL = URL(filePath: swiftFilePath, expandingTilde: true)
        
        let catalogFileContents = try String(contentsOf: catalogFileURL, encoding: .utf8)
        let table = catalogFileURL.deletingPathExtension().lastPathComponent
        
        let sourceCode = if FileManager.default.fileExists(at: swiftFileURL) {
            try String(contentsOf: swiftFileURL, encoding: .utf8)
        } else {
            "\n"
        }
        
        let request = LocalizedStringResourceGenerator.Request(
            catalogFileContents: catalogFileContents,
            table: table == Default.table ? nil : table,
            bundle: bundle,
            sourceCode: sourceCode,
            resourceTypeName: resourceTypeName)
        
        let generator = LocalizedStringResourceGenerator(
            commentDirectives: .init(verbatim: CommentDirective.verbatim))
        
        return try generator.generate(for: request)
    }
    
    private func writeCode(_ code: String) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        
        try code.write(to: tempFileURL, atomically: false, encoding: .utf8)
        
        try FileManager.default.compareAndReplaceItem(at: swiftFilePath, withItemAt: tempFileURL)
    }
}
