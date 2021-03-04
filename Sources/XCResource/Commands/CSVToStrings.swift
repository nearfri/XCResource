import Foundation
import ArgumentParser
import LocStringGen
import XCResourceUtil

struct CSVToStrings: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "csv2strings",
        abstract: "CSV를 strings로 변환",
        discussion: """
            CSV 파일을 Localizable.strings 파일로 변환한다.
            """)
    
    // MARK: - Default values
    
    enum Default {
        static let headerStyle: LanguageFormatterStyle = .long(Locale.current)
        static let tableName: String = "Localizable"
        static let includesEmptyFields: Bool = false
    }
    
    // MARK: - Arguments
    
    @Option var csvPath: String
    
    @Option(help: ArgumentHelp(valueName: LanguageFormatterStyle.joinedValueStrings))
    var headerStyle: LanguageFormatterStyle = Default.headerStyle
    
    @Option var resourcesPath: String
    
    @Option var tableName: String = Default.tableName
    
    @Flag(name: .customLong("include-empty-fields"))
    var includesEmptyFields: Bool = Default.includesEmptyFields
    
    // MARK: - Run
    
    mutating func run() throws {
        let stringsByLanguage = try generateStrings()
        
        for (language, strings) in stringsByLanguage {
            try writeStrings(strings, for: language)
        }
    }
    
    private func generateStrings() throws -> [LanguageID: String] {
        let request = LocalizationImporter.Request(
            tableSource: .file(URL(fileURLWithExpandingTildeInPath: csvPath)),
            includesEmptyFields: includesEmptyFields)
        
        let importer = LocalizationImporter()
        importer.headerStyle = headerStyle
        
        return try importer.generate(for: request)
    }
    
    private func writeStrings(_ strings: String, for language: LanguageID) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        let outputFileURL = stringsFileURL(for: language)
        
        try (strings + "\n").write(to: tempFileURL, atomically: false, encoding: .utf8)
        try FileManager.default.compareAndReplaceItem(at: outputFileURL, withItemAt: tempFileURL)
    }
    
    private func stringsFileURL(for language: LanguageID) -> URL {
        return URL(fileURLWithExpandingTildeInPath: resourcesPath)
            .appendingPathComponents(language: language.rawValue, tableName: tableName)
    }
}
