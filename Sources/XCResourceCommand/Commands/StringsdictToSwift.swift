import Foundation
import ArgumentParser
import LocStringKeyGen
import XCResourceUtil

struct StringsdictToSwift: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "stringsdict2swift",
        abstract: "stringsdict를 Swift 소스 코드로 변환",
        discussion: """
            Localizable.stringsdict 파일로 Swift enum 코드를 생성한다.
            """)
    
    // MARK: - Default values
    
    enum Default {
        static let tableName: String = "Localizable"
        static let language: String = "en"
    }
    
    // MARK: - Arguments
    
    @Option var resourcesPath: String
    
    @Option var tableName: String = Default.tableName
    
    @Option var language: String = Default.language
    
    @Option var swiftPath: String
    
    // MARK: - Run
    
    mutating func run() throws {
        let code = try generateCode()
        
        try writeCode(code)
    }
    
    private func generateCode() throws -> String {
        let tableType = StringTableType.stringsdict
        
        let stringsdictFileURL = URL(fileURLWithExpandingTildeInPath: resourcesPath)
            .appendingPathComponents(language: language, tableName: tableName, tableType: tableType)
        
        let request = StringKeyGenerator.Request(
            stringsFileURL: stringsdictFileURL,
            sourceCodeURL: URL(fileURLWithExpandingTildeInPath: swiftPath))
        
        let generator = StringKeyGenerator.stringsdictToStringKey()
        
        return try generator.generate(for: request)
    }
    
    private func writeCode(_ code: String) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        
        try code.write(to: tempFileURL, atomically: false, encoding: .utf8)
        
        try FileManager.default.compareAndReplaceItem(at: swiftPath, withItemAt: tempFileURL)
    }
}
