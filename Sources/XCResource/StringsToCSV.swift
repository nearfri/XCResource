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
    
    // MARK: - Arguments
    
    @Option var resourcesPath: String
    
    @Option var tableName: String = "Localizable"
    
    @Option var developmentLocalization: String = "en"
    
    @Option var csvPath: String
    
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
            preferredLanguages: [LanguageID(rawValue: developmentLocalization)])
        
        return try LocalizationExporter().generate(for: request)
    }
    
    private func writeCSV(_ csv: String) throws {
        let csvAsData = csv.data(using: .utf8)!
        let csvFileData = writeBOM ? Data([0xEF, 0xBB, 0xBF] + csvAsData) : csvAsData
        
        let csvURL = URL(fileURLWithExpandingTildeInPath: csvPath)
        
        try csvFileData.write(to: csvURL, options: .atomic)
    }
}
