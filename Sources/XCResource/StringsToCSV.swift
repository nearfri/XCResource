import Foundation
import ArgumentParser
import LocStringGen
import XCResourceUtil

extension LanguageFormatterStyle: ExpressibleByArgument {
    public init?(argument: String) {
        if argument == "short" {
            self = .short
            return
        }
        
        if argument == "long" {
            self = .long(Locale.current)
            return
        }
        
        if argument.hasPrefix("long-") {
            let localeID = String(argument.dropFirst("long-".count))
            self = .long(Locale(identifier: localeID))
            return
        }
        
        return nil
    }
    
    public var defaultValueDescription: String {
        switch self {
        case .short:
            return "short"
        case .long(let locale):
            return locale == .current ? "long" : "long-\(locale.identifier)"
        }
    }
    
    public static var allValueStrings: [String] {
        return ["short", "long", "long-<language>"]
    }
    
    static var joinedArgumentName: String {
        return allValueStrings.joined(separator: "|")
    }
}

struct StringsToCSV: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "strings2csv",
        abstract: "strings를 CSV로 변환",
        discussion: """
            Localizable.strings 파일을 CSV 파일로 변환한다.
            """)
    
    // MARK: - Arguments
    
    @Option var resourcesPath: String
    
    @Option var tableName: String = "Localizable"
    
    @Option var developmentLanguage: String = "en"
    
    @Option var csvPath: String
    
    @Option(help: ArgumentHelp(valueName: LanguageFormatterStyle.joinedArgumentName))
    var headerStyle: LanguageFormatterStyle = .long(Locale.current)
    
    @Flag var writeBOM: Bool = false
    
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
        let csvFileData = writeBOM ? Data([0xEF, 0xBB, 0xBF] + csvAsData) : csvAsData
        
        let csvURL = URL(fileURLWithExpandingTildeInPath: csvPath)
        
        try csvFileData.write(to: csvURL, options: .atomic)
    }
}
