import Foundation
import ArgumentParser
import XCResourceUtil
import LocStringResourceGen

struct XCStringsToSwift: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "xcstrings2swift",
        abstract: "xcstrings를 Swift 소스 코드로 변환",
        discussion: """
            Localizable.xcstrings 파일로 LocalizedStringResource 값을 생성한다.
            """)
    
    // MARK: - Default Values
    
    enum Default {
        static let table: String = "Localizable"
        static let bundle: LocalizationItem.BundleDescription = .main
        static let resourceTypeName: String = "LocalizedStringResource"
    }
    
    // MARK: - Arguments
    
    @Option var catalogPath: String
    
    @Option var bundle: LocalizationItem.BundleDescription = Default.bundle
    
    @Option var swiftPath: String
    
    @Option var resourceTypeName: String = Default.resourceTypeName
    
    // MARK: - Run
    
    mutating func run() throws {
        let code = try generateCode()
        
        try writeCode(code)
    }
    
    private func generateCode() throws -> String {
        let catalogFileURL = URL(fileURLWithExpandingTildeInPath: catalogPath)
        let swiftFileURL = URL(fileURLWithExpandingTildeInPath: swiftPath)
        
        let catalogFileContents = try String(contentsOf: catalogFileURL)
        let table = catalogFileURL.deletingPathExtension().lastPathComponent
        let sourceCode = try String(contentsOf: swiftFileURL)
        
        let request = LocalizedStringResourceGenerator.Request(
            catalogFileContents: catalogFileContents,
            table: table == Default.table ? nil : table,
            bundle: bundle,
            sourceCode: sourceCode,
            resourceTypeName: resourceTypeName)
        
        let generator = LocalizedStringResourceGenerator()
        
        return try generator.generate(for: request)
    }
    
    private func writeCode(_ code: String) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        
        try code.write(to: tempFileURL, atomically: false, encoding: .utf8)
        
        try FileManager.default.compareAndReplaceItem(at: swiftPath, withItemAt: tempFileURL)
    }
}
