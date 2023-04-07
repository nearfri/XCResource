import Foundation
import ArgumentParser
import LocStringKeyGen
import XCResourceUtil

struct StringsToSwift: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "strings2swift",
        abstract: "strings를 Swift 소스 코드로 변환",
        discussion: """
            Localizable.strings 파일로 Swift enum 코드를 생성한다.
            
            - strings에 없는 enum case는 제거된다.
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
        let stringsFileURL = URL(fileURLWithExpandingTildeInPath: resourcesPath)
            .appendingPathComponents(language: language, tableName: tableName)
        
        let request = StringKeyGenerator.Request(
            stringsFileURL: stringsFileURL,
            sourceCodeURL: URL(fileURLWithExpandingTildeInPath: swiftPath))
        
        let generator = StringKeyGenerator.stringsToStringKey()
        
        return try generator.generate(for: request)
    }
    
    private func writeCode(_ code: String) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        
        try code.write(to: tempFileURL, atomically: false, encoding: .utf8)
        
        try FileManager.default.compareAndReplaceItem(at: swiftPath, withItemAt: tempFileURL)
    }
}
