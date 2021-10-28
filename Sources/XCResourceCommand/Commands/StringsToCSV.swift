import Foundation
import ArgumentParser
import LocStringGen
import XCResourceUtil

struct StringsToCSV: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "strings2csv",
        abstract: "strings를 CSV로 변환",
        discussion: """
            Localizable.strings 파일을 CSV 파일로 변환한다.
            """)
    
    // MARK: - Default values
    
    enum Default {
        static let tableName: String = "Localizable"
        static let developmentLanguage: String = "en"
        static let headerStyle: LanguageFormatterStyle = .long(Locale.current)
        static let writesBOM: Bool = false
    }
    
    // MARK: - Arguments
    
    @Option var resourcesPath: String
    
    @Option var tableName: String = Default.tableName
    
    @Option var developmentLanguage: String = Default.developmentLanguage
    
    @Option var csvPath: String
    
    @Option(help: ArgumentHelp(valueName: LanguageFormatterStyle.joinedValueStrings))
    var headerStyle: LanguageFormatterStyle = Default.headerStyle
    
    @Flag(name: .customLong("write-bom"))
    var writesBOM: Bool = Default.writesBOM
    
    // MARK: - Run
    
    mutating func run() throws {
        let csv = try generateCSV()
        try writeCSV(csv)
    }
    
    private func generateCSV() throws -> String {
        let request = LocalizationExporter.Request(
            resourcesURL: URL(fileURLWithExpandingTildeInPath: resourcesPath),
            tableName: tableName,
            preferredLanguages: [LanguageID(developmentLanguage)])
        
        let exporter = LocalizationExporter()
        exporter.headerStyle = headerStyle
        
        return try exporter.generate(for: request)
    }
    
    private func writeCSV(_ csv: String) throws {
        let csvAsData = csv.data(using: .utf8)!
        let csvFileData = writesBOM ? Data([0xEF, 0xBB, 0xBF] + csvAsData) : csvAsData
        
        let csvURL = URL(fileURLWithExpandingTildeInPath: csvPath)
        
        try csvFileData.write(to: csvURL, options: .atomic)
    }
}
