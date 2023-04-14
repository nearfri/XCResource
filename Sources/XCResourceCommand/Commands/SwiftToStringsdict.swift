import Foundation
import ArgumentParser
import LocStringsGen
import LocStringCore
import XCResourceUtil

struct SwiftToStringsdict: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "swift2stringsdict",
        abstract: "Swift 소스 코드를 stringsdict로 변환",
        discussion: """
            enum 타입을 담고 있는 소스 코드에서 case와 주석을 추출해 Localizable.stringsdict 파일을 생성한다.
            
            - case의 rawValue를 key로 하고, --localization-config 옵션에 따라 value를 결정한다.
            - 소스 코드에 없는 key는 stringsdict 파일에서 제거된다.
            """)
    
    // MARK: - Default values
    
    enum Default {
        static let tableName: String = "Localizable"
        static let configurations: [LanguageAndStringsdictConfiguration] = [
            .init(language: LanguageID.allSymbol,
                  configuration: .init(mergeStrategy: .doNotAdd))
        ]
        static let omitsComments: Bool = false
        static let sortsByKey: Bool = false
    }
    
    // MARK: - Arguments
    
    @Option var swiftPath: String
    
    @Option var resourcesPath: String
    
    @Option var tableName: String = Default.tableName
    
    @Option(name: .customLong("language-config"),
            parsing: .upToNextOption,
            help: ArgumentHelp(
                "Languages and configurations to convert.",
                discussion: """
                    If "\(LanguageID.allSymbol)" is specified at language position, \
                    all languages are converted.
                    """,
                valueName: LanguageAndStringsdictConfiguration.usageDescription))
    var configurations: [LanguageAndStringsdictConfiguration] = Default.configurations
    
    @Flag(name: .customLong("sort-by-key"))
    var sortsByKey: Bool = Default.sortsByKey
    
    // MARK: - Run
    
    mutating func run() throws {
        let stringsdictsByLanguage = try generateStringsdicts()
        
        for (language, stringsdict) in stringsdictsByLanguage {
            try writeStringsdict(stringsdict, for: language)
        }
    }
    
    private func generateStringsdicts() throws -> [LanguageID: String] {
        let request = StringKeyToStringsdictGenerator.Request(
            sourceCodeURL: URL(fileURLWithExpandingTildeInPath: swiftPath),
            resourcesURL: URL(fileURLWithExpandingTildeInPath: resourcesPath),
            tableName: tableName,
            configurationsByLanguage: configurations.configurationsByLanguage,
            sortOrder: sortsByKey ? .key : .occurrence)
        
        let generator = StringKeyToStringsdictGenerator(
            commandNameSet: .init(include: CommentCommandName.targetStringsdict))
        
        return try generator.generate(for: request)
    }
    
    private func writeStringsdict(_ stringsdict: String, for language: LanguageID) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        let outputFileURL = stringsdictFileURL(for: language)
        
        try (stringsdict + "\n").write(to: tempFileURL, atomically: false, encoding: .utf8)
        try FileManager.default.compareAndReplaceItem(at: outputFileURL, withItemAt: tempFileURL)
    }
    
    private func stringsdictFileURL(for language: LanguageID) -> URL {
        return URL(fileURLWithExpandingTildeInPath: resourcesPath)
            .appendingPathComponents(language: language.rawValue,
                                     tableName: tableName,
                                     tableType: .stringsdict)
    }
}
